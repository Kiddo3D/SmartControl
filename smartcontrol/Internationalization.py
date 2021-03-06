import json
import os
import sys

from .Resources import Resources


class Internationalization(object):
    _instance = None

    ENCODING = "UTF-8"
    DIRECTORY = "i18n"
    NATIVE = "en"

    def __init__(self):
        self._locale = Internationalization.NATIVE

    @classmethod
    def instance(cls):
        if Internationalization._instance is None:
            Internationalization._instance = cls()
        return Internationalization._instance

    def load(self, locale):
        locale = locale.split("_")[0]
        if (locale == Internationalization.NATIVE or locale not in self.availableLocales()):
            self._locale = Internationalization.NATIVE
            self._data = None
        else:
            self._locale = locale
            with open(self._internationalization(), encoding=Internationalization.ENCODING) as f:
                self._data = json.load(f)

    def get(self, key, args=[]):
        value = self._data[key] if self._data is not None else key
        return value.format(*args)

    def locale(self):
        return self._locale

    def availableLocales(self):
        locales = [f.split(".")[0] for f in os.listdir(self._internationalizationPath())]
        locales.append(Internationalization.NATIVE)
        return locales

    def _internationalization(self):
        return os.path.join(self._internationalizationPath(), self._locale + ".json")

    def _internationalizationPath(self):
        return os.path.join(Resources.path(), Internationalization.DIRECTORY)
