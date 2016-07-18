from PyQt5.QtCore import QObject, pyqtSlot, pyqtProperty, pyqtSignal

class PrinterProxy(QObject):
    selected = pyqtSignal()

    def __init__(self, printerConnectionManager):
        super().__init__()
        self._printerConnectionManager = printerConnectionManager
        self._printer = None

    @pyqtSlot(str)
    def select(self, id):
        if self._printer is not None:
            pass # desconectar
        self._printer = self._printerConnectionManager.get(id)
        # conectar
        self.selected.emit()

    @pyqtSlot()
    def stop(self):
        self._printer.stop()

    @pyqtSlot()
    def loadFilament(self):
        self._printer.loadFilament()

    @pyqtSlot()
    def unloadFilament(self):
        self._printer.unloadFilament()

    @pyqtSlot()
    def printGcode(self):
        # TODO gcode
        self._printer.printGcode(None)

    @pyqtProperty(str, notify=selected)
    def state(self):
        return self._printer.state.name() if self._printer else None

    @pyqtProperty(str, notify=selected)
    def name(self):
        return self._printer.name if self._printer else None

    @pyqtProperty(str, notify=selected)
    def port(self):
        return self._printer.port.name if self._printer else None

    @pyqtProperty(str, notify=selected)
    def portType(self):
        return self._printer.port.type.name() if self._printer else None

    @pyqtProperty(int, notify=selected)
    def transferProgress(self):
        return int(self._printer.transferProgress)/int(self._printer.transferTotal)*100 if self._printer and int(self._printer.transferTotal) else 0

    @pyqtProperty(int, notify=selected)
    def warmupProgress(self):
        return float(self._printer.temperature)/int(self._printer.targetTemperature)*100 if self._printer and self._printer.targetTemperature else 0

    @pyqtProperty(int, notify=selected)
    def printProgress(self):
        return int(self._printer.printProgress)/int(self._printer.printTotal)*100 if self._printer and int(self._printer.printTotal) else 0
