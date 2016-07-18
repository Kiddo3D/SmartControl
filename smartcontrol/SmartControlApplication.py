import locale
import os
import sys

from PyQt5.QtCore import QCoreApplication
from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine

from .Internationalization import Internationalization
from .Resources import Resources
from .Theme import Theme
from .binder.Binder import Binder
from .printer.PrinterConnectionManager import PrinterConnectionManager


try:
    from smartcontrol.Version import Version
except ImportError:
    version = "0.0.0"

class SmartControlApplication(QGuiApplication):
    _instance = None

    WINDOW_ICON = "smart-control.png"
    DEFAULT_THEME = "default"
    MAIN_QML = "main.qml"

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
        self._engine = QQmlApplicationEngine()
        self._internationalization = Internationalization()
        self._theme = Theme()
        self._printerConnectionManager = PrinterConnectionManager()

    @classmethod
    def instance(cls):
        if SmartControlApplication._instance is None:
            SmartControlApplication._instance = cls()
        return SmartControlApplication._instance

    def run(self):
        self._internationalization.load(locale.getdefaultlocale()[0])
        self._theme.load(SmartControlApplication.DEFAULT_THEME)
        self._printerConnectionManager.start()

        self.aboutToQuit.connect(self._onClose)
        self.setWindowIcon(QIcon(Resources.icon(SmartControlApplication.WINDOW_ICON)))
        Binder(self._internationalization, self._theme, self._printerConnectionManager).register()

        self._engine = QQmlApplicationEngine()
        if sys.platform == "win32":
            self._engine.addImportPath(os.path.join(os.path.abspath(os.path.dirname(sys.executable)), "qml"))
        self._engine.load(Resources.qml(SmartControlApplication.MAIN_QML))

        sys.exit(self.exec_())

    def _onClose(self):
        self._printerConnectionManager.stop()
