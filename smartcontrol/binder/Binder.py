from PyQt5.QtQml import qmlRegisterSingletonType

from .InternationalizationProxy import InternationalizationProxy
from .PrinterProxy import PrinterProxy
from .ThemeProxy import ThemeProxy


class Binder:
    def __init__(self, internationalization, theme, printerConnectionManager):
        self._internationalization = internationalization
        self._theme = theme
        self._printerConnectionManager = printerConnectionManager
    
    def register(self):
        qmlRegisterSingletonType(InternationalizationProxy, "SC", 1, 0, "i18n", self._createInternationalizationProxy)
        qmlRegisterSingletonType(ThemeProxy, "SC", 1, 0, "Theme", self._createThemeProxy)
        qmlRegisterSingletonType(ThemeProxy, "SC", 1, 0, "printer", self._createPrinterProxy)

    def _createInternationalizationProxy(self, engine, scriptEngine):
        return InternationalizationProxy(self._internationalization)

    def _createThemeProxy(self, engine, scriptEngine):
        return ThemeProxy(self._theme)

    def _createPrinterProxy(self, engine, scriptEngine):
        return PrinterProxy(self._printerConnectionManager)
