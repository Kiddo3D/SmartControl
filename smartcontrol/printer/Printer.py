import functools
import re


class Printer(object):
    COMMAND_SEPARATOR = "\n"

    def __init__(self, data):
        self.name = data["name"]
        self.bps = data["bps"]
        self.bootToken = data["bootToken"]
        self.eol = data["eol"]
        self.chunkSize = data["chunkSize"]
        self.targetTemperature = data["targetTemperature"]
        self.sendChunkCommand = data["commands"]["sendChunk"]
        self.sendChunkWithChecksumCommand = data["commands"]["sendChunkWithChecksum"]
        self.initializeCommands = data["actions"]["initialize"].split(Printer.COMMAND_SEPARATOR)
        self.preTransferCommands = data["actions"]["transfer"]["pre"].split(Printer.COMMAND_SEPARATOR)
        self.postTransferCommands = data["actions"]["transfer"]["post"].split(Printer.COMMAND_SEPARATOR)
        self.printCommands = data["actions"]["print"].split(Printer.COMMAND_SEPARATOR)
        self.stopTransferCommands = data["actions"]["stop"]["transfer"].split(Printer.COMMAND_SEPARATOR)
        self.stopPrintCommands = data["actions"]["stop"]["print"].split(Printer.COMMAND_SEPARATOR)
        self.unloadFilamentCommands = data["actions"]["filament"]["unload"].split(Printer.COMMAND_SEPARATOR)
        self.loadFilamentCommands = data["actions"]["filament"]["load"].split(Printer.COMMAND_SEPARATOR)
        self.readyResponseRegex = re.compile(data["responses"]["ready"])
        self.temperatureResponseRegex = re.compile(data["responses"]["temperature"])
        self.firmwareInfoResponseRegex = re.compile(data["responses"]["firmwareInfo"])
        self.printingProgressResponseRegex = re.compile(data["responses"]["printingProgress"])
        self.notPrintingResponseRegex = re.compile(data["responses"]["notPrinting"])
        self.resendResponseRegex = re.compile(data["responses"]["resend"])
        self.errorResponse = re.compile(data["responses"]["error"])
        self.monitoringFrequency = data["monitoring"]["frequency"]
        self.printingMonitoringCommands = data["monitoring"]["printing"].split(Printer.COMMAND_SEPARATOR)

    def sendChunkCommand(self, i, data):
        data = self._sendChunkCommand.format(i, data)
        checksum = functools.reduce(lambda x, y: x ^ y, map(ord, data))
        return self._sendChunkWithChecksumCommand.format(data, checksum)
