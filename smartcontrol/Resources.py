import os
import sys


class Resources(object):
    @classmethod
    def getIcon(cls, key):
        return os.path.join(cls.getPath(), "icons", key)

    @classmethod
    def getPath(cls):
        base = None
        if "python" in os.path.basename(sys.executable):
            base = os.path.abspath(os.path.dirname(sys.argv[0]))
        elif sys.platform == "win32":
            base = os.path.abspath(os.path.dirname(sys.executable))
        else:
            base = os.path.join(os.path.abspath(os.path.dirname(sys.executable)), "..", "share", "smartcontrol")
        return os.path.join(base, "resources")
