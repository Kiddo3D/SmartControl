from collections import deque
from enum import Enum
from threading import RLock
from threading import Timer
import time

from PyQt5.QtCore import QThread, pyqtSignal
from serial import Serial 

from smartcontrol.Printers import Printers


class PrinterConnection(QThread):
    class State(Enum):
        DISCONNECTED = 0
        INITIALIZING = 1
        IDLE = 2
        TRANSFERING = 3
        PRINTING = 4

    WRITE_TIMEOUT = 1
    WRITE_RETRIES = 2
    WRITE_RETRY_WAIT = 1
    READ_TIMEOUT = 1
    ENCODING = "UTF-8"
    BOOT_READ_MAX = 150
    BOOT_WAIT = 1
    READY_TIMEOUT = 5

    stateChanged = pyqtSignal("QString")
    temperatureChanged = pyqtSignal(float, float)
    printProgressChanged = pyqtSignal(int, int)

    def __init__(self, port):
        super().__init__()
        self._queue = deque()
        self._lock = RLock()
        self._connection = None
        self._ready = True
        self._lastReady = 0
        self._gcode = None
        self._monitorTimer = None
        self._transferIndex = 1

        self.state = PrinterConnection.State.DISCONNECTED
        self.id = port.name
        self.port = port
        self.firmwareVersion = None
        self.transferProgress = 0
        self.transferTotal = 0
        self.temperature = 0
        self.printProgress = 0
        self.printTotal = 0

    @property
    def name(self):
        return self._printer.name

    @property
    def targetTemperature(self):
        return self._printer.targetTemperature

    def open(self):
        if self.state != PrinterConnection.State.DISCONNECTED:
            return
        try:
            # Use the first printer for now
            self._printer = Printers().instance().availablePrinters()[0]
            self._connection = Serial(self.port.name, self._printer.bps, timeout=PrinterConnection.READ_TIMEOUT, write_timeout=PrinterConnection.WRITE_TIMEOUT)
            # Read first bytes of boot searching for token 
            boot = self._connection.read_until(self._printer.bootToken.encode(PrinterConnection.ENCODING), PrinterConnection.BOOT_READ_MAX).decode(PrinterConnection.ENCODING)
            if not boot.endswith(self._printer.bootToken):
                raise Exception("Not a Kiddo Printer")
            # Wait for boot to completely load
            time.sleep(PrinterConnection.BOOT_WAIT)
            # Initialize
            self._setState(PrinterConnection.State.INITIALIZING)
            self._queue.clear()
            self._queue.extend(((self._initialize, []), (self._monitor, [])))
            self.start()
        except Exception as e:
            print(str(e))
            self._close()
            raise e

    def close(self):
        with self._lock:
            self._queue.appendleft((self._close, []))

    def printGcode(self, gcode):
        with self._lock:
            self._queue.append((self._printGcode, [gcode]))

    def loadFilament(self):
        with self._lock:
            self._queue.append((self._loadFilament, []))

    def unloadFilament(self):
        with self._lock:
            self._queue.append((self._unloadFilament, []))

    def stop(self):
        with self._lock:
            self._queue.appendleft((self._stop, []))

    def run(self):
        try:
            while self.state != PrinterConnection.State.DISCONNECTED:
                if self._ready and self._queue:
                    with self._lock:
                        task = self._queue.popleft()
                        task[0](*task[1])
                        # If still ready execute next task
                        if self._ready:
                            continue
                self._parseResponse(self._connection.readline().decode(PrinterConnection.ENCODING))
        except Exception as e:
            print(e)
            self._close()

    def _parseResponse(self, response):
        match = self._printer.readyResponseRegex.match(response)
        if match:
            self._ready = True
            # Embedded response
            if match.lastindex:
                self._parseResponse(match.group(1))
            return
        elif time.time() > self._lastReady + PrinterConnection.READY_TIMEOUT:
            self._ready = True

        match = self._printer.temperatureResponseRegex.match(response)
        if match:
            self._setTemperature(match.group(1))
            return

        match = self._printer.firmwareInfoResponseRegex.match(response)
        if match:
            self._setFirmwareVersion(match.group(1))
            return

        match = self._printer.printProgressResponseRegex.match(response)
        if match:
            self._setState(PrinterConnection.State.PRINTING)
            self._setPrintProgress(match.group("progress"), match.group("total"))
            return

        match = self._printer.notPrintingResponseRegex.match(response)
        if match:
            self._setState(PrinterConnection.State.IDLE)
            return

        match = self._printer.resendResponseRegex.match(response)
        if match.groups():
            self._transferIndex = int(match.group(1))
        else:
            self._transferIndex -= 1
        return

        # TODO No implementado: M36 (info de archivo en impresion)
        # {"err":0,"size":457574,"height":4.00,"layerHeight":0.25,"filament":[6556.3],"generatedBy":"Slic3r 1.1.7 on 2014-11-09 at 17:11:32"} 
        # "name"
        # "estimatedTime"
        # start Time?

        match = self._printer.errorResponse.match(response)
        if match:
            pass  # TODO raise Exception("Error: " + response)

    def _send(self, command, retries=-1):
        try:
            self._connection.write((command + self._printer.eol).encode(PrinterConnection.ENCODING))
            self._ready = False
            self._lastReady = time.time()
        except Exception as e:
            if retries < 0:
                retries = PrinterConnection.WRITE_RETRIES
            if retries > 0:
                # Wait before retrying
                time.sleep(PrinterConnection.WRITE_RETRY_WAIT)
                self._send(command, retries - 1)
            else:
                raise e

    def _setState(self, state):
        if self.state != state:
            self.state = state
            self.stateChanged.emit(self.state.name)

    def _setFirmwareVersion(self, firmwareVersion): 
        self.firmwareVersion = firmwareVersion
        print("Firmware Version: " + firmwareVersion)

    def _setTemperature(self, temperature):
        self.temperature = float(temperature)
        self.temperatureChanged.emit(self.temperature, self.targetTemperature)

    def _setPrintProgress(self, printProgress, printTotal):
        self.printProgress = int(printProgress)
        self.printTotal = int(printTotal)
        self.printProgressChanged.emit(self.printProgress, self.printTotal)

    def _initialize(self):
        if self.state != PrinterConnection.State.INITIALIZING:
            return
        commands = [(self._send, [command]) for command in self._printer.initializeCommands]
        self._queue.extend(commands)

    def _monitor(self):
        with self._lock:
            if self.state == PrinterConnection.State.PRINTING:
                commands = [(self._send, [command]) for command in self._printer.printingMonitoringCommands]
                self._queue.extendleft(reversed(commands))
            if self.state != PrinterConnection.State.DISCONNECTED:
                self._monitorTimer = Timer(self._printer.monitoringFrequency, self._queue.append, [(self._monitor, [])])
                self._monitorTimer.start()

    def _close(self):
        self._setState(PrinterConnection.State.DISCONNECTED)
        if self._monitorTimer is not None:
            self._monitorTimer.cancel()
        if self._connection is not None:
            self._connection.close()

    def _transfer(self):
        data = self._gcode[(self._transferIndex - 1) * self._printer.dataSize:self._transferIndex * self._printer.dataSize]
        self._send(self._printer.dataCommand(self._transferIndex, data))
        if self._transferIndex * self._printer.dataSize < len(self._gcode):
            self._transferIndex += 1
            self._queue.appendleft((self._transfer, []))

    def _printGcode(self, gcode):
        if self.state != PrinterConnection.State.IDLE:
            return
        self._gcode = gcode
        self._transferIndex = 1
        commands = [(self._setState, [PrinterConnection.State.TRANSFERING])]
        commands.extend([(self._send, [command]) for command in self._printer.preTransferCommands])
        commands.append((self._transfer, []))
        commands.extend([(self._send, [command]) for command in self._printer.postTransferCommands])
        commands.append((self._setState, [PrinterConnection.State.PRINTING]))
        commands.extend([(self._send, [command]) for command in self._printer.printCommands])
        self._queue.extendleft(reversed(commands))

    def _stop(self):
        commands = []
        if self.state == PrinterConnection.State.TRANSFERING:
            commands.append([(self._send, [command]) for command in self._printer.stopTransferCommands])
        elif self.state == PrinterConnection.State.PRINTING:
            commands.append([(self._send, [command]) for command in self._printer.stopPrintCommands])
        else:
            return
        commands.append((self._setState, [PrinterConnection.State.IDLE]))
        commands.append((self._queue.clear, []))
        self._queue.extendleft(reversed(commands))

    def _loadFilament(self):
        if self.state != PrinterConnection.State.IDLE:
            return
        commands = [(self._send, [command]) for command in self._printer.loadFilamentCommands]
        self._queue.extendleft(reversed(commands))

    def _unloadFilament(self):
        if self.state != PrinterConnection.State.IDLE:
            return
        commands = [(self._send, [command]) for command in self._printer.unloadFilamentCommands]
        self._queue.extendleft(reversed(commands))
