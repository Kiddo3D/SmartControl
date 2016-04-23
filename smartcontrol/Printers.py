import json
import os
import sys

from .Resources import Resources
from .printer.Printer import Printer


class Printers(object):
    ENCODING = "UTF-8"
    DIRECTORY = "printers"

    def __init__(self):
        self._printers = []
        self.load()

    @classmethod
    def instance(cls):
        if Printers._instance is None:
            Printers._instance = cls()
        return Printers._instance

    def load(self):
        printers = []
        for fileName in os.listdir(self._printersPath()):
            with open(os.path.join(self._printersPath(), fileName), encoding=self.ENCODING) as file:
                printers.append(Printer(json.load(file)))
        self._printers = printers

    def availablePrinters(self):
        return self._printers

    def _printersPath(self):
        return os.path.join(Resources.getPath(), self.DIRECTORY)

    _instance = None
