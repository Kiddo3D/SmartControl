from PyQt5.QtCore import QObject, pyqtSlot


class InternationalizationProxy(QObject):
    def __init__(self, internationalization):
        super().__init__()
        self._internationalization = internationalization

    @pyqtSlot(str, "QStringList", result=str)
    @pyqtSlot(str, result=str)
    def get(self, key, args=[]):
        return self._internationalization.get(key, args)
