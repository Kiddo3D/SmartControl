from enum import Enum


class Port(object):
    class Type(Enum):
        USB = 1
        BLUETOOTH = 2

    def __init__(self, name, type):
        self.name = name
        self.type = type
