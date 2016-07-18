import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtQuick.Window 2.1

import SC 1.0 as SC
import "util.js" as Util

Window {
	id: window
	flags: Qt.Window | Qt.WindowSystemMenuHint | Qt.WindowTitleHint | Qt.WindowMinimizeButtonHint | Qt.WindowCloseButtonHint
	width: SC.Theme.get("window.width")*Screen.devicePixelRatio
	minimumWidth: width
	maximumWidth: width
	height: SC.Theme.get("window.aspectRatio")*width
	minimumHeight: height
	maximumHeight: height
	title: "Smart Control"
	visible: true
	color: SC.Theme.get("window.color")

	FontLoader {
		source: SC.Theme.font("window.fonts.light")
	}
	FontLoader {
		source: SC.Theme.font("window.fonts.normal")
	}
	FontLoader {
		source: SC.Theme.font("window.fonts.medium")
	}

	ColumnLayout {
		anchors.fill: parent
		spacing: 0

		Rectangle {
			id: header
			anchors.left: parent.left
			anchors.right: parent.right
			Layout.preferredHeight: 0.09*parent.height
			color: SC.Theme.get("window.header.color")

			Rectangle {
				id: menuButton
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				width: parent.height
				color: SC.Theme.get("window.header.menuButton.color")

				Image {
					id: menuButtonIcon
					source: SC.Theme.icon("window.header.menuButton.icon")
					anchors.centerIn: parent
					width: 0.5*parent.width
					fillMode: Image.PreserveAspectFit
				}

				MouseArea {
					anchors.fill: parent
					cursorShape: Qt.PointingHandCursor
					onClicked: menuWithHeader.state = menuWithHeader.state == "VISIBLE" ? "HIDDEN" : "VISIBLE"
				}	
			}
			Text {
				id: title
				text: "Smart Control"
				anchors.left: menuButton.right
				anchors.right: logo.parent.left
				anchors.verticalCenter: parent.verticalCenter
				horizontalAlignment: Text.AlignHCenter
				color: SC.Theme.get("window.header.title.color")
				font.family: SC.Theme.get("window.header.title.font.family")
				font.weight: Util.fontWeight(SC.Theme.get("window.header.title.font.weight"))
				onWidthChanged: Util.setFontPixelSize(this, 0.35*parent.height)
			}

			Item {
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				width: parent.height
	
				Image {
					id: logo
					source: SC.Theme.image("window.header.logo")
					anchors.centerIn: parent
					width: menuButtonIcon.width
					fillMode: Image.PreserveAspectFit
				}
			}
		}

		Item {
			anchors.left: parent.left
			anchors.right: parent.right
			Layout.fillHeight: true
			Loader {
				id: sectionLoader
				source: "SmartControl.qml"
				anchors.fill:parent
				
			}
		}
	}

	Item {
		id: menuWithHeader
		state: "HIDDEN"
		z: parent.z + 1
		anchors.top: parent.top
		anchors.bottom: parent.bottom
		width: parent.width - header.height
		clip: true

		ColumnLayout {
			anchors.fill: parent
			spacing: 0

			Rectangle {
				id: menuHeader
				anchors.left: parent.left
				anchors.right: parent.right
				Layout.preferredHeight: header.height
				color: SC.Theme.get("window.menu.header.color")

				Item {
					id: closeMenuButton
					anchors.top: parent.top
					anchors.left: parent.left
					anchors.bottom: parent.bottom
					width: parent.height

					Image {
						source: SC.Theme.icon("window.menu.header.menuButton.icon")
						anchors.centerIn: parent
						width: menuButtonIcon.width
						fillMode: Image.PreserveAspectFit
					}
				}

				Text {
					text: SC.i18n.get("Menu")
					anchors.top: parent.top
					anchors.bottom: parent.bottom
					anchors.left: closeMenuButton.right
					verticalAlignment: Text.AlignVCenter
					font.pixelSize: title.font.pixelSize
					color: SC.Theme.get("window.menu.header.title.color")
					font.family: SC.Theme.get("window.menu.header.title.font.family")
					font.weight: Util.fontWeight(SC.Theme.get("window.menu.header.title.font.weight"))
				}
			}

			Loader {
				id: menuLoader
				source: "Menu.qml"
				anchors.left: parent.left
				anchors.right: parent.right
				Layout.fillHeight: true
			}
		}

		Connections {
			target: menuLoader.item
			onSelected: {
				if (source.match("^http:") != "http:") {
					title.text = name;
					sectionLoader.source = source;
				} else {
					Qt.openUrlExternally(source)
				}
				menuWithHeader.state = "HIDDEN";
			}
		}

		states: [
			State {
				name: "HIDDEN"
				AnchorChanges { target: menuWithHeader; anchors.right: parent.left; anchors.left: undefined }
			},
			State {
				name: "VISIBLE"
				AnchorChanges { target: menuWithHeader; anchors.right: undefined; anchors.left: parent.left }
			}
		]

		transitions: Transition {
			AnchorAnimation { duration: SC.Theme.get("window.menu.animation.duration") }
		}
	}
}
