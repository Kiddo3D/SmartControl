import QtQuick 2.2
import QtQuick.Layouts 1.1

import SC 1.0 as SC

ColumnLayout {
	anchors.fill: parent
	anchors.topMargin: 0.01*parent.height
	anchors.leftMargin: (menuButton.width - menuButtonIcon.width)/2
	anchors.rightMargin: anchors.leftMargin
	anchors.bottomMargin: anchors.leftMargin
	spacing: 0

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

	Text {
		id: fileNameLabel
		text: "A File Name"
		anchors.left: parent.left
		anchors.right: parent.right
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
		color: SC.Theme.get("window.smartControl.fileName.color")
		font.pixelSize: 0.45*height * font.pixelSize / contentHeight
		Layout.preferredHeight: 0.07*parent.height
		font.family: SC.Theme.get("window.smartControl.fileName.font.family")
		font.weight: SC.Theme.get("window.smartControl.fileName.font.weight")
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
						font.pixelSize: 0.35*lineCount*parent.height * font.pixelSize / height
						font.family: SC.Theme.get("window.smartControl.progressBar.label.font.family")
						font.weight: SC.Theme.get("window.smartControl.progressBar.label.font.weight")
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
						font.pixelSize: 0.35*lineCount*parent.height * font.pixelSize / height
						font.family: SC.Theme.get("window.smartControl.progressBar.label.font.family")
						font.weight: SC.Theme.get("window.smartControl.progressBar.label.font.weight")
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
						font.pixelSize: 0.35*lineCount*parent.height * font.pixelSize / height
						font.family: SC.Theme.get("window.smartControl.progressBar.label.font.family")
						font.weight: SC.Theme.get("window.smartControl.progressBar.label.font.weight")
					}
				}
			}
		}
	}

	Text {
		id: remainingTimeLabel
		property string remainingTime: "00:00"
		text: SC.i18n.get("REMAINING TIME: {0}hs", remainingTime)
		anchors.left: parent.left
		anchors.right: parent.right
		verticalAlignment: Text.AlignVCenter
		horizontalAlignment: Text.AlignHCenter
		color: SC.Theme.get("window.smartControl.remainingTime.color")
		font.pixelSize: height * font.pixelSize / contentHeight
		font.family: SC.Theme.get("window.smartControl.remainingTime.font.family")
		font.weight: SC.Theme.get("window.smartControl.remainingTime.font.weight")
		Layout.preferredHeight: 0.035*parent.height
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
				text: SC.i18n.get("Choose File")
				Layout.preferredHeight: parent.rowHeight
			}
			SmartControlButton {
				text: SC.i18n.get("Stop Print Job")
				Layout.preferredHeight: parent.rowHeight
			}
			SmartControlButton {
				text: SC.i18n.get("Load Material")
				Layout.preferredHeight: parent.rowHeight
			}
			SmartControlButton {
				text: SC.i18n.get("Unload Material")
				Layout.preferredHeight: parent.rowHeight
			}
			SmartControlButton {
				text: SC.i18n.get("Print")
				Layout.preferredHeight: parent.rowHeight
				anchors.leftMargin: parent.width/4
				anchors.rightMargin: anchors.leftMargin
			}
		}
	}
}
