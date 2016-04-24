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
		color: SC.Theme.get("window.smartControl.printers.color")

		Rectangle {
			id: printersContainerBar
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.verticalCenter: parent.bottom
			height: 0.03*parent.height
			color: SC.Theme.get("window.smartControl.printers.bar.color")

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
		color: "transparent"
		radius: 5
		Layout.preferredHeight: 0.03*parent.height

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
			text: "A File Name"
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
					id: warmUpProgressBar
				}
				Item {
					anchors.top: warmUpProgressBar.bottom
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
				}
			}
			SmartControlButton {
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Load Filament")
				}
			}
			SmartControlButton {
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Unload Filament")
				}
			}
			SmartControlButton {
				anchors.leftMargin: parent.width/4
				anchors.rightMargin: anchors.leftMargin
				height: parent.rowHeight
				Layout.preferredHeight: height
				action: Action {
					text: SC.i18n.get("Print")
				}
			}
		}
	}
}
