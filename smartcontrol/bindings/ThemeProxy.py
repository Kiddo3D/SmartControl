from PyQt5.QtCore import QObject, pyqtSlot, QUrl

from smartcontrol.Theme import Theme


class ThemeProxy(QObject):

    def __init__(self, parent=None):
        super().__init__(parent)

    @pyqtSlot(str, result=str)
    def get(self, key):
        return Theme.getInstance().get(key)

    @pyqtSlot(str, result=QUrl)
    def getIcon(self, key):
        return QUrl.fromLocalFile(Theme.getInstance().getIcon(key))

    @pyqtSlot(str, result=QUrl)
    def getImage(self, key):
        return QUrl.fromLocalFile(Theme.getInstance().getImage(key))

    @pyqtSlot(str, result=QUrl)
    def getFont(self, key):
        return QUrl.fromLocalFile(Theme.getInstance().getFont(key))
