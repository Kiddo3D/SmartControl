import QtQuick 2.2
import QtQuick.Layouts 1.1

import SC 1.0 as SC

Rectangle {
	id: menu
	color: SC.Theme.get("window.menu.color")

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
		MenuItem {
			id: smartControlMenuItem
			property string source: "SmartControl.qml"
			text: "Smart Control"
			iconSource: SC.Theme.icon("window.menu.items.smartControl.icon")
			borderColor: SC.Theme.get("window.menu.items.smartControl.border.color")
			selected: true
			onClicked: menu.select(this)
			Layout.preferredHeight: parent.rowHeight
		}
		MenuItem {
			id: libraryMenuItem
			property string source: SC.i18n.get("http://biblioteca.kiddo3d.com/")
			text: SC.i18n.get("Kiddo Library")
			iconSource: SC.Theme.icon("window.menu.items.library.icon")
			borderColor: SC.Theme.get("window.menu.items.library.border.color")
			onClicked: menu.select(this)
			Layout.preferredHeight: parent.rowHeight
		}
		MenuItem {
			id: configurationMenuItem
			property string source: "Configuration.qml"
			text: SC.i18n.get("Configuration")
			iconSource: SC.Theme.icon("window.menu.items.configuration.icon")
			borderColor: SC.Theme.get("window.menu.items.configuration.border.color")
			onClicked: menu.select(this)
			Layout.preferredHeight: parent.rowHeight
		}
		MenuItem {
			id: webMenuItem
			property string source: SC.i18n.get("http://www.kiddo3d.com/")
			text: SC.i18n.get("Kiddo3D.com.ar")
			iconSource: SC.Theme.icon("window.menu.items.site.icon")
			borderColor: SC.Theme.get("window.menu.items.site.border.color")
			onClicked: menu.select(this)
			Layout.preferredHeight: parent.rowHeight
		}
	}

	signal itemSelected(string name, string source)

	function select(menuItem) {
		if (menuItem.source.match("^http:") != "http:") {
			smartControlMenuItem.selected = false;
			configurationMenuItem.selected = false;
			menuItem.selected = true;
		}
		menu.itemSelected(menuItem.text, menuItem.source)
	}
}
