import os
import sys


class Resources(object):
    DIRECTORY = "resources"
    ICONS_DIRECTORY = "icons"
    QML_DIRECTORY = "qml"

    @classmethod
    def icon(cls, key):
        return os.path.join(cls.path(), Resources.ICONS_DIRECTORY, key)

    @classmethod
    def qml(cls, key):
        return os.path.join(Resources.path(), Resources.QML_DIRECTORY, key)

    @classmethod
    def path(cls):
        base = None
        if "python" in os.path.basename(sys.executable):
            base = os.path.abspath(os.path.dirname(sys.argv[0]))
            if not sys.platform == "win32":
                base = os.path.join(base, "..", "share", "smartcontrol")
        elif hasattr(sys, "frozen"):
            base = os.path.abspath(os.path.dirname(sys.executable))

        return os.path.join(base, Resources.DIRECTORY)
