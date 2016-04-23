import locale
import os
import sys

from PyQt5.QtCore import QCoreApplication
from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine

from .Internationalization import Internationalization
from .Resources import Resources
from .Theme import Theme
from .bindings.Bindings import Bindings
from .printer.PrinterConnectionManager import PrinterConnectionManager


try:
    from smartcontrol.Version import Version
except ImportError:
    version = "0.0.0"

class SmartControlApplication(QGuiApplication):
    def __init__(self, **kwargs):
        if sys.platform == "win32":
            if hasattr(sys, "frozen"):
                QCoreApplication.addLibraryPath(os.path.join(os.path.abspath(os.path.dirname(sys.executable)), "PyQt5", "plugins"))
            else:
                import site
                for dir in site.getsitepackages():
                    QCoreApplication.addLibraryPath(os.path.join(dir, "PyQt5", "plugins"))
        super().__init__(sys.argv, **kwargs)
        self.setApplicationVersion(version)
        self._mainQml = "main.qml"
        self._engine = None
        self._printerConnectionManager = None

    @classmethod
    def instance(cls):
        if SmartControlApplication._instance is None:
            SmartControlApplication._instance = cls()
        return SmartControlApplication._instance

    def run(self):
        Bindings.register()

        self.aboutToQuit.connect(self._onClose)

        Internationalization.instance().load(locale.getdefaultlocale()[0])
        Theme.instance().load("default")

        self.setWindowIcon(QIcon(Resources.icon("smart-control.png")))

        self._printerConnectionManager = PrinterConnectionManager()
        self._printerConnectionManager.start()

        self._engine = QQmlApplicationEngine()
        if sys.platform == "win32":
            self._engine.addImportPath(os.path.join(os.path.abspath(os.path.dirname(sys.executable)), "qml"))
        self._engine.load(os.path.join(Resources.path(), "qml", self._mainQml))

        sys.exit(self.exec_())

    def _onClose(self):
        self._printerConnectionManager.stop()

    _instance = None
