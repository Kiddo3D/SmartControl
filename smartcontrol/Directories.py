import os
import sys


class Directories:
    @classmethod
    def getApplicationPath(self):
        if "python" in os.path.basename(sys.executable):
            return os.path.abspath(os.path.dirname(sys.argv[0]))
        else:
            return os.path.abspath(os.path.dirname(sys.executable))
