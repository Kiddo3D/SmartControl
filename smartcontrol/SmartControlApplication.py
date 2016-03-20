import os
import sys
import locale

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine

from smartcontrol.Internationalization import Internationalization
from smartcontrol.Theme import Theme
from smartcontrol.bindings.Bindings import Bindings


class SmartControlApplication(QGuiApplication):
    def __init__(self, **kwargs):
        super().__init__(sys.argv, **kwargs)
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
        self._engine.load(os.path.join("resources", "qml", "main.qml"))

        sys.exit(self.exec_())
 
    _instance = None
