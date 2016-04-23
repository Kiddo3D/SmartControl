from enum import Enum

class Port(object):
    class Type(Enum):
        USB = 1
        BLUETOOTH = 2

    def __init__(self, name, type):
        self._name = name
        self._type = type

    def name(self):
        return self._name

    def type(self):
        return self._type
