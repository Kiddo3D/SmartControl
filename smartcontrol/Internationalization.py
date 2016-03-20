import json
import os
from re import _locale


class Internationalization:
    def __init__(self):
        self._native = "en"
        self._locale = self._native

    @classmethod
    def getInstance(cls):
        if Internationalization._instance is None:
            Internationalization._instance = cls()
        return Internationalization._instance

    def load(self, locale):
        locale = locale.split("_")[0]
        if (locale == self._native or locale not in self.getAvailableLocales()):
            self._locale = self._native
            self._data = None
        else:
            self._locale = locale
            with open(self._getInternationalization()) as f:
                self._data = json.load(f)

    def get(self, key, args = []):
        value = self._data[key] if self._data is not None else key
        return value.format(*args)

    def getLocale(self):
        return self._locale

    def getAvailableLocales(self):
        locales = [f.split(".")[0] for f in os.listdir(self._getInternationalizationRoot())]
        locales.append(self._native)
        return locales

    def _getInternationalization(self):
        return os.path.join(self._getInternationalizationRoot(), self._locale + ".json")

    def _getInternationalizationRoot(self):
        return os.path.abspath(os.path.join("resources", "i18n"))

    _instance = None
