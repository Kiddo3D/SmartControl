import os
import sys
import locale

from PyQt5.QtCore import QCoreApplication
from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

from smartcontrol.Directories import Directories
from smartcontrol.Internationalization import Internationalization
from smartcontrol.Theme import Theme
from smartcontrol.bindings.Bindings import Bindings


class SmartControlApplication(QGuiApplication):
    def __init__(self, **kwargs):
        QCoreApplication.addLibraryPath(os.path.join(Directories.getApplicationPath(), "PyQt5", "plugins"))
        if sys.platform == "win32" and not hasattr(sys, "frozen"):
            import site
            for dir in site.getsitepackages():
                QCoreApplication.addLibraryPath(os.path.join(dir, "PyQt5", "plugins"))
        super().__init__(sys.argv, **kwargs)
        self._mainQml = "main.qml"
        self._engine = None

    @classmethod
    def getInstance(cls):
        if SmartControlApplication._instance is None:
            SmartControlApplication._instance = cls()
        return SmartControlApplication._instance

    def run(self):
        Bindings.register()

        Internationalization.getInstance().load(locale.getdefaultlocale()[0])
        Theme.getInstance().load("default")

        self._engine = QQmlApplicationEngine()
        self._engine.addImportPath(os.path.join(Directories.getApplicationPath(), "qml"))
        self._engine.load(os.path.join(Directories.getApplicationPath(), "resources", "qml", self._mainQml))

        sys.exit(self.exec_())

    _instance = None
