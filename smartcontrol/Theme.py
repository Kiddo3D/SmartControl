import json
import os
import sys

from .Resources import Resources


class Theme(object):
    _instance = None

    ENCODING = "UTF-8"
    DIRECTORY = "themes"
    ICONS_DIRECTORY = "icons"
    IMAGES_DIRECTORY = "images"
    FONTS_DIRECTORY = "fonts"

    def __init__(self):
        _name = None
        _data = None

    @classmethod
    def instance(cls):
        if Theme._instance is None:
            Theme._instance = cls()
        return Theme._instance

    def load(self, theme):
        self._name = theme
        with open(self._theme(), encoding=Theme.ENCODING) as f:
            self._data = self._flattenDict(json.load(f))

    def get(self, key):
        return self._data[key]

    def icon(self, key):
        return os.path.join(self._themePath(), Theme.ICONS_DIRECTORY, self.get(key))

    def image(self, key):
        return os.path.join(self._themePath(), Theme.IMAGES_DIRECTORY, self.get(key))

    def font(self, key):
        return os.path.join(self._themePath(), Theme.FONTS_DIRECTORY, self.get(key))

    def name(self):
        return self._name

    def availableThemes(self):
        return [f for f in os.listdir(self._themesPath())]

    def _theme(self):
        return os.path.join(self._themePath(), self._name + ".json")

    def _themePath(self):
        return os.path.join(self._themesPath(), self._name)

    def _themesPath(self):
        return os.path.join(Resources.path(), Theme.DIRECTORY)

    def _flattenDict(self, init, lkey=""):
        result = {}
        for rkey, val in init.items():
            key = lkey + rkey
            if isinstance(val, dict):
                result.update(self._flattenDict(val, key + "."))
            else:
                result[key] = val
        return result
