import functools
import re


class Printer(object):
    COMMAND_SEPARATOR = "\n"

    def __init__(self, data):
        self._name = data["name"]
        self._bps = data["bps"]
        self._bootToken = data["bootToken"]
        self._eol = data["eol"]
        self._chunkSize = data["chunkSize"]
        self._targetTemperature = data["targetTemperature"]
        self._sendChunkCommand = data["commands"]["sendChunk"]
        self._sendChunkWithChecksumCommand = data["commands"]["sendChunkWithChecksum"]
        self._initializeCommands = data["actions"]["initialize"].split(Printer.COMMAND_SEPARATOR)
        self._preTransferCommands = data["actions"]["transfer"]["pre"].split(Printer.COMMAND_SEPARATOR)
        self._postTransferCommands = data["actions"]["transfer"]["post"].split(Printer.COMMAND_SEPARATOR)
        self._printCommands = data["actions"]["print"].split(Printer.COMMAND_SEPARATOR)
        self._stopTransferCommands = data["actions"]["stop"]["transfer"].split(Printer.COMMAND_SEPARATOR)
        self._stopPrintCommands = data["actions"]["stop"]["print"].split(Printer.COMMAND_SEPARATOR)
        self._unloadFilamentCommands = data["actions"]["filament"]["unload"].split(Printer.COMMAND_SEPARATOR)
        self._loadFilamentCommands = data["actions"]["filament"]["load"].split(Printer.COMMAND_SEPARATOR)
        self._readyResponseRegex = re.compile(data["responses"]["ready"])
        self._temperatureResponseRegex = re.compile(data["responses"]["temperature"])
        self._firmwareInfoResponseRegex = re.compile(data["responses"]["firmwareInfo"])
        self._printingProgressResponseRegex = re.compile(data["responses"]["printingProgress"])
        self._notPrintingResponseRegex = re.compile(data["responses"]["notPrinting"])
        self._resendResponseRegex = re.compile(data["responses"]["resend"])
        self._errorResponse = re.compile(data["responses"]["error"])
        self._monitoringFrequency = data["monitoring"]["frequency"]
        self._printingMonitoringCommands = data["monitoring"]["printing"].split(Printer.COMMAND_SEPARATOR)

    def name(self):
        return self._name

    def bps(self):
        return self._bps

    def bootToken(self):
        return self._bootToken

    def eol(self):
        return self._eol

    def chunkSize(self):
        return self._chunkSize

    def targetTemperature(self):
        return self._targetTemperature

    def sendChunkCommand(self, i, data):
        data = self._sendChunkCommand.format(i, data)
        checksum = functools.reduce(lambda x, y: x ^ y, map(ord, data))
        return self._sendChunkWithChecksumCommand.format(data, checksum)

    def initializeCommands(self):
        return self._initializeCommands

    def preTransferCommands(self):
        return self._preTransferCommands

    def postTransferCommands(self):
        return self._postTransferCommands

    def printCommands(self):
        return self._printCommands

    def stopTransferCommands(self):
        return self._stopTransferCommands

    def stopPrintCommands(self):
        return self._stopPrintCommands

    def unloadFilamentCommands(self):
        return self._unloadFilamentCommands

    def loadFilamentCommands(self):
        return self._loadFilamentCommands

    def readyResponseRegex(self):
        return self._readyResponseRegex

    def temperatureResponseRegex(self):
        return self._temperatureResponseRegex

    def firmwareInfoResponseRegex(self):
        return self._firmwareInfoResponseRegex

    def printingProgressResponseRegex(self):
        return self._printingProgressResponseRegex

    def notPrintingResponseRegex(self):
        return self._notPrintingResponseRegex

    def resendResponseRegex(self):
        return self._resendResponseRegex

    def errorResponse(self):
        return self._errorResponse

    def monitoringFrequency(self):
        return self._monitoringFrequency

    def printingMonitoringCommands(self):
        return self._printingMonitoringCommands
