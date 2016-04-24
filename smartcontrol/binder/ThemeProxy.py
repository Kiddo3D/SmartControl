from PyQt5.QtCore import QObject, pyqtSlot, QUrl


class ThemeProxy(QObject):
    def __init__(self, theme):
        super().__init__()
        self._theme = theme

    @pyqtSlot(str, result=str)
    def get(self, key):
        return self._theme.get(key)

    @pyqtSlot(str, result=QUrl)
    def icon(self, key):
        return QUrl.fromLocalFile(self._theme.icon(key))

    @pyqtSlot(str, result=QUrl)
    def image(self, key):
        return QUrl.fromLocalFile(self._theme.image(key))

    @pyqtSlot(str, result=QUrl)
    def font(self, key):
        return QUrl.fromLocalFile(self._theme.font(key))
