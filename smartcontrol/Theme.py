import json
import os
import sys

from smartcontrol.Resources import Resources


class Theme(object):
    def __init__(self):
        _name = None
        _data = None

    @classmethod
    def getInstance(cls):
        if Theme._instance is None:
            Theme._instance = cls()
        return Theme._instance

    def load(self, theme):
        self._name = theme
        with open(self._getTheme()) as f:
            self._data = self._flattenDict(json.load(f))

    def get(self, key):
        return self._data[key]

    def getIcon(self, key):
        return os.path.join(self._getThemePath(), "icons", self.get(key))

    def getImage(self, key):
        return os.path.join(self._getThemePath(), "images", self.get(key))

    def getFont(self, key):
        return os.path.join(self._getThemePath(), "fonts", self.get(key))

    def getName(self):
        return self._name

    def getAvailableThemes(self):
        return [f for f in os.listdir(self._getThemesPath())]

    def _getTheme(self):
        return os.path.join(self._getThemePath(), self._name + ".json")

    def _getThemePath(self):
        return os.path.join(self._getThemesPath(), self._name)

    def _getThemesPath(self):
        return os.path.join(Resources.getPath(), "themes")

    def _flattenDict(self, init, lkey=""):
        result = {}
        for rkey, val in init.items():
            key = lkey + rkey
            if isinstance(val, dict):
                result.update(self._flattenDict(val, key + "."))
            else:
                result[key] = val
        return result

    _instance = None
