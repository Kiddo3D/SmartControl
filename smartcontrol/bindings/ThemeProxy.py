from PyQt5.QtCore import QObject, pyqtSlot, QUrl

from smartcontrol.Theme import Theme


class ThemeProxy(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)

    @pyqtSlot(str, result=str)
    def get(self, key):
        return Theme.instance().get(key)

    @pyqtSlot(str, result=QUrl)
    def icon(self, key):
        return QUrl.fromLocalFile(Theme.instance().icon(key))

    @pyqtSlot(str, result=QUrl)
    def image(self, key):
        return QUrl.fromLocalFile(Theme.instance().image(key))

    @pyqtSlot(str, result=QUrl)
    def font(self, key):
        return QUrl.fromLocalFile(Theme.instance().font(key))
