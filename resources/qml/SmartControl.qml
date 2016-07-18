import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Dialogs 1.1
import QtQuick.Layouts 1.1

import SC 1.0 as SC
import "util.js" as Util

ColumnLayout {
	anchors.fill: parent
	anchors.topMargin: 0.01*(parent ? parent.height : 0)
	anchors.leftMargin: (menuButton.width - menuButtonIcon.width)/2
	anchors.rightMargin: anchors.leftMargin
	anchors.bottomMargin: anchors.leftMargin
	spacing: 0

	FileDialog {
	    id: fileDialog
	    folder: shortcuts.documents
	    nameFilters: ["*.gcode"]
	    onAccepted: {
	    }
	}

	Rectangle {
		id: printersContainer
		anchors.left: parent.left
		anchors.right: parent.right
		Layout.preferredHeight: 0.115*parent.height
		color: SC.Theme.get("window.smartControl.printer.color")

		Item {
			id: previousPrinterButton
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.bottom: parent.bottom
			width: menuButton.width - (menuButton.width - menuButtonIcon.width)/2
			Image {
				source: SC.Theme.icon("window.smartControl.printer.arrow.left")
				anchors.centerIn: parent
				height: 0.4*parent.height
				fillMode: Image.PreserveAspectFit
				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
				}
			}
		}
		Item {
			anchors.top: parent.top
			anchors.left: previousPrinterButton.right
			anchors.right: nextPrinterButton.left
			anchors.bottom: parent.bottom
			anchors.margins: 0.25*height
			Item {
				id: connectionTypeIcon
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				width: parent.height
				AnimatedImage {
					source: SC.Theme.icon("window.smartControl.printer.type.usb")
					anchors.fill: parent
					fillMode: Image.PreserveAspectFit
				}
			}
			Text {
				id: printerName
				text: SC.printer.name
				anchors.left: connectionTypeIcon.right
				anchors.right: parent.right
				anchors.leftMargin: 0.15*parent.height
				color: SC.Theme.get("window.smartControl.printer.name.text.color")
				font.family: SC.Theme.get("window.smartControl.printer.name.text.font.family")
				font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.printer.name.text.font.weight"))
				onWidthChanged: Util.setFontPixelSize(this, 0.6*parent.height)
				Component.onCompleted: Util.setFontPixelSize(this, 0.6*parent.height)
			}
			Text {
				text: SC.printer.port
				anchors.top: printerName.bottom
				anchors.left: printerName.left
				anchors.right: parent.right
				color: SC.Theme.get("window.smartControl.printer.port.text.color")
				font.family: SC.Theme.get("window.smartControl.printer.port.text.font.family")
				font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.printer.port.text.font.weight"))
				font.pixelSize: printerName.font.pixelSize/2
			}
		}
		Item {
			id: nextPrinterButton
			anchors.top: parent.top
			anchors.right: parent.right
			anchors.bottom: parent.bottom
			width: menuButton.width - (menuButton.width - menuButtonIcon.width)/2
			Image {
				source: SC.Theme.icon("window.smartControl.printer.arrow.right")
				anchors.centerIn: parent
				height: 0.4*parent.height
				fillMode: Image.PreserveAspectFit
				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
				}
			}
		}
		Rectangle {
			id: printersContainerBar
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.bottom
			height: 0.03*parent.height
			color: SC.Theme.get("window.smartControl.printer.bar.color")

			Rectangle {
				id: printersContainerBarPoint
				anchors.right: parent.right
				anchors.verticalCenter: parent.verticalCenter
				height: 3.5*parent.height
				width: 1.5*height
				color: parent.color
			}
		}
	}

	Rectangle {
		id: infoContainer
		anchors.left: parent.left
		anchors.right: parent.right
		z: parent.z - 1
		color: SC.Theme.get("window.smartControl.info.color")
		radius: 5
		Layout.preferredHeight: 0.03*parent.height

		Text {
			z: parent.z + 2
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
			text: SC.i18n.get("Keep the device close to the printer")
			color: SC.Theme.get("window.smartControl.info.text.color")
			font.family: SC.Theme.get("window.smartControl.info.text.font.family")
			font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.info.text.font.weight"))
			visible: !Qt.colorEqual(parent.color, "transparent")
			onWidthChanged: Util.setFontPixelSize(this, 0.9*parent.height)
			Component.onCompleted: Util.setFontPixelSize(this, 0.9*parent.height)
		}

		Rectangle {
			color: parent.color
			anchors.top: parent.top
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.bottom: parent.verticalCenter
		}
	}

	Item {
		anchors.left: parent.left
		anchors.right: parent.right
		Layout.preferredHeight: 0.07*parent.height
		Text {
			id: fileNameLabel
			text: "..."
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
			color: SC.Theme.get("window.smartControl.fileName.color")
			font.family: SC.Theme.get("window.smartControl.fileName.font.family")
			font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.fileName.font.weight"))
			Component.onCompleted: Util.setFontPixelSize(this, 0.45*parent.height)
			onWidthChanged: Util.setFontPixelSize(this, 0.45*parent.height)
		}
	}

	Item {
// TODO SACAR!!!
MouseArea{
anchors.fill: parent
onClicked: SC.printer.select("COM3")
}
		id: progressBarsContainer
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: menuButtonIcon.width
		anchors.rightMargin: anchors.leftMargin
		Layout.preferredHeight: 0.245*parent.height

		RowLayout{
			anchors.fill: parent
			spacing: 0.05*parent.width
		
			Item {
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				Layout.fillWidth: true
		
				CircularProgressBar {
					id: transferProgressBar
					progress: SC.printer.transferProgress
				}
				Item {
					anchors.top: transferProgressBar.bottom
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					Text {
						text: SC.i18n.get("Transfering File")
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						horizontalAlignment: Text.AlignHCenter
						wrapMode: Text.WordWrap
						color: SC.Theme.get("window.smartControl.progressBar.label.color")
						font.family: SC.Theme.get("window.smartControl.progressBar.label.font.family")
						font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.progressBar.label.font.weight"))
						Component.onCompleted: Util.setFontPixelSize(this, 0.35*parent.height)
						onWidthChanged: Util.setFontPixelSize(this, 0.35*parent.height)
					}
				}
			}

			Item {
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				Layout.fillWidth: true
	
				CircularProgressBar {
					id: warmupProgressBar
					progress: SC.printer.warmupProgress
				}
				Item {
					anchors.top: warmupProgressBar.bottom
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					Text {
						text: SC.i18n.get("Warming Up")
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						horizontalAlignment: Text.AlignHCenter
						wrapMode: Text.WordWrap
						color: SC.Theme.get("window.smartControl.progressBar.label.color")
						font.family: SC.Theme.get("window.smartControl.progressBar.label.font.family")
						font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.progressBar.label.font.weight"))
						Component.onCompleted: Util.setFontPixelSize(this, 0.35*parent.height)
						onWidthChanged: Util.setFontPixelSize(this, 0.35*parent.height)
					}
				}
			}

			Item {
				anchors.top: parent.top
				anchors.bottom: parent.bottom
				Layout.fillWidth: true
	
				CircularProgressBar {
					id: printProgressBar
					progress: SC.printer.printProgress
				}
				Item {
					anchors.top: printProgressBar.bottom
					anchors.left: parent.left
					anchors.right: parent.right
					anchors.bottom: parent.bottom
					Text {
						text: SC.i18n.get("Printing")
						anchors.left: parent.left
						anchors.right: parent.right
						anchors.verticalCenter: parent.verticalCenter
						horizontalAlignment: Text.AlignHCenter
						wrapMode: Text.WordWrap
						color: SC.Theme.get("window.smartControl.progressBar.label.color")
						font.family: SC.Theme.get("window.smartControl.progressBar.label.font.family")
						font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.progressBar.label.font.weight"))
						Component.onCompleted: Util.setFontPixelSize(this, 0.35*parent.height)
						onWidthChanged: Util.setFontPixelSize(this, 0.35*parent.height)
					}
				}
			}
		}
	}

	Item {
		anchors.left: parent.left
		anchors.right: parent.right
		Layout.preferredHeight: 0.035*parent.height
		Text {
			id: remainingTimeLabel
			property string remainingTime: "00:00"
			text: SC.i18n.get("REMAINING TIME: {0}hs", remainingTime)
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			horizontalAlignment: Text.AlignHCenter
			color: SC.Theme.get("window.smartControl.remainingTime.color")
			font.family: SC.Theme.get("window.smartControl.remainingTime.font.family")
			font.weight: Util.fontWeight(SC.Theme.get("window.smartControl.remainingTime.font.weight"))
			Component.onCompleted: Util.setFontPixelSize(this, 0.9*parent.height)
			onWidthChanged: Util.setFontPixelSize(this, 0.9*parent.height)
		}
	}

	Item {
		id: bar
		anchors.left: parent.left
		anchors.right: parent.right
		Layout.preferredHeight: 0.055*parent.height

		Rectangle {
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.verticalCenter
			height: printersContainerBar.height
			color: SC.Theme.get("window.smartControl.bar.color")

			Rectangle {
				anchors.left: parent.left
				anchors.verticalCenter: parent.verticalCenter
				height: printersContainerBarPoint.height
				width: printersContainerBarPoint.width
				color: parent.color
			}
		}
	}

	Item {
		id: buttonsContainer
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.leftMargin: progressBarsContainer.anchors.leftMargin
		anchors.rightMargin: anchors.leftMargin
		Layout.fillHeight: true

		ColumnLayout {
			anchors.fill: parent
			property int rowHeight: parent.height/SC.Theme.get("window.smartControl.buttons.maxButtons")

			SmartControlButton {
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Choose File")
					onTriggered: fileDialog.open()
				}
			}
			SmartControlButton {
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Stop Print Job")
					onTriggered: SC.printer.stop()
				}
			}
			SmartControlButton {
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Load Filament")
					onTriggered: SC.printer.loadFilament()
				}
			}
			SmartControlButton {
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Unload Filament")
					onTriggered: SC.printer.unloadFilament()
				}
			}
			SmartControlButton {
				anchors.leftMargin: parent.width/4
				anchors.rightMargin: anchors.leftMargin
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Print")
					onTriggered: SC.printer.printGcode()
				}
			}
		}
	}
}
