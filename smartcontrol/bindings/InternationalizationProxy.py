from PyQt5.QtCore import QObject, pyqtSlot

from smartcontrol.Internationalization import Internationalization


class InternationalizationProxy(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)

    @pyqtSlot(str, "QStringList", result=str)
    @pyqtSlot(str, result=str)
    def get(self, key, args = []):
        return Internationalization.getInstance().get(key, args)
