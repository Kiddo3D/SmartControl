import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

import SC 1.0 as SC

Rectangle {
	id: menu
	color: SC.Theme.get("window.menu.color")

	signal selected(string name, string source)

	ColumnLayout {
		property int rowHeight: menu.height/SC.Theme.get("window.menu.maxRows")
		spacing: 0
		anchors.left: parent.left
		anchors.right: parent.right

		Image {
			source: SC.Theme.image("window.menu.logo")
			anchors.left: parent.left
			anchors.right: parent.right
			anchors.leftMargin: closeMenuButton.width
			anchors.rightMargin: anchors.leftMargin
			Layout.preferredHeight: 2*parent.rowHeight
			fillMode: Image.PreserveAspectFit
		}
		ExclusiveGroup {
			id: menuButtonGroup
		}
		MenuButton {
			borderColor: SC.Theme.get("window.menu.items.smartControl.border.color")
			Layout.preferredHeight: parent.rowHeight
			action: Action {
				text: "Smart Control"
				iconSource: SC.Theme.icon("window.menu.items.smartControl.icon")
				checkable: true
				exclusiveGroup: menuButtonGroup
				checked: true
				onTriggered: menu.selected(text, "SmartControl.qml")
			}
		}
		MenuButton {
			borderColor: SC.Theme.get("window.menu.items.library.border.color")
			Layout.preferredHeight: parent.rowHeight
			action: Action {
				text: SC.i18n.get("Kiddo Library")
				iconSource: SC.Theme.icon("window.menu.items.library.icon")
				onTriggered: menu.selected(text, SC.i18n.get("http://biblioteca.kiddo3d.com/"))
			}
		}
		MenuButton {
			borderColor: SC.Theme.get("window.menu.items.configuration.border.color")
			Layout.preferredHeight: parent.rowHeight
			action: Action {
				text: SC.i18n.get("Configuration")
				iconSource: SC.Theme.icon("window.menu.items.configuration.icon")
				checkable: true
				exclusiveGroup: menuButtonGroup
				onTriggered: menu.selected(text, "Configuration.qml")
			}
		}
		MenuButton {
			borderColor: SC.Theme.get("window.menu.items.site.border.color")
			Layout.preferredHeight: parent.rowHeight
			action: Action {
				text: SC.i18n.get("Kiddo3D.com")
				iconSource: SC.Theme.icon("window.menu.items.site.icon")
				onTriggered: menu.selected(text, SC.i18n.get("http://www.kiddo3d.com/"))
			}
		}
	}
}
