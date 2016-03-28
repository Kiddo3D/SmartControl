from PyQt5.QtQml import qmlRegisterSingletonType

from smartcontrol.Internationalization import Internationalization
from smartcontrol.Theme import Theme
from smartcontrol.bindings.InternationalizationProxy import InternationalizationProxy
from smartcontrol.bindings.ThemeProxy import ThemeProxy


class Bindings:
    @classmethod
    def register(cls):
        qmlRegisterSingletonType(InternationalizationProxy, "SC", 1, 0, "i18n", cls.createInternationalizationProxy)
        qmlRegisterSingletonType(ThemeProxy, "SC", 1, 0, "Theme", cls.createThemeProxy)

    @classmethod
    def createInternationalizationProxy(cls, engine, scriptEngine):
        return InternationalizationProxy()

    @classmethod
    def createThemeProxy(cls, engine, scriptEngine):
        return ThemeProxy()
