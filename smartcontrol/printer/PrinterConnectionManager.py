from multiprocessing.dummy import Pool
import sys
from threading import Thread
import time

from PyQt5.QtCore import QObject, pyqtSignal
import serial
from serial.tools import list_ports

from .Port import Port
from .PrinterConnection import PrinterConnection
from .avr_isp import stk500v2


class PrinterConnectionManager(QObject, Thread):
    INTERVAL = 10

    connectionEstablished = pyqtSignal()

    def __init__ (self):
      super().__init__()
      self._running = False
      self._connections = []

    def run(self):
        try:
            while self._running:
                # List ports
                ports = []
                if sys.platform == "win32":
                    ports = [Port(port.device, (Port.Type.USB if "USB" in port.description else Port.Type.BLUETOOTH)) for port in list_ports.comports()]
                elif sys.platform == "linux":
                    ports = []
                else:
                    ports = []
                # Filter open ports
                ports = [port for port in ports if port.name() not in [connection.port().name() for connection in self._connections]]
                # Give priority to USB ports
                ports = sorted(ports, key=lambda port: 0 if port.type() == Port.Type.USB else 1)
                # Attempt connections
                if ports and self._running:
                    pool = Pool(len(ports))
                    for port in ports:
                        pool.apply_async(self._attemptConnection, [port], callback=self._connections.append) 
                    pool.close()
                    pool.join()
                # Wait
                for i in range(self.INTERVAL):
                    if not self._running:
                        break
                    time.sleep(1)
        finally:
            # Close all connections on stop
            for connection in self._connections:
                connection.close()
            self._connections = []

    def start(self):
        self._running = True
        Thread.start(self)

    def stop(self):
        self._running = False

    def _attemptConnection(self, port):
        connection = PrinterConnection(port)
        connection.open()
        return connection
