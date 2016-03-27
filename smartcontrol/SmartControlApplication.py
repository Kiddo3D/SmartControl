import os
import sys
import locale

from PyQt5.QtCore import QCoreApplication
from PyQt5.QtGui import QGuiApplication, QIcon
from PyQt5.QtQml import QQmlApplicationEngine

from smartcontrol.Resources import Resources
from smartcontrol.Internationalization import Internationalization
from smartcontrol.Theme import Theme
from smartcontrol.bindings.Bindings import Bindings

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
        self._version = version
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

        self.setWindowIcon(QIcon(Resources.getIcon("smart-control.png")))

        self._engine = QQmlApplicationEngine()
        if sys.platform == "win32":
            self._engine.addImportPath(os.path.join(os.path.abspath(os.path.dirname(sys.executable)), "qml"))
        self._engine.load(os.path.join(Resources.getPath(), "qml", self._mainQml))

        sys.exit(self.exec_())

    def getVersion(self):
        return self._version

    _instance = None
