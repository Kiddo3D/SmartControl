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
            if not sys.platform == "win32":
                base = os.path.join(base, "..", "share", "smartcontrol")
        elif hasattr(sys, "frozen"):
            base = os.path.abspath(os.path.dirname(sys.executable))

        return os.path.join(base, "resources")
