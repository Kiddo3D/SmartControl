import QtQuick 2.5
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.4

import SC 1.0 as SC

Button {
	anchors.left: parent.left
	anchors.right: parent.right
	style: ButtonStyle {
		background: Rectangle {
			color: control.enabled ? (control.pressed ? SC.Theme.get("window.smartControl.buttons.pressed.color") : SC.Theme.get("window.smartControl.buttons.normal.color")) : SC.Theme.get("window.smartControl.buttons.disabled.color")
			border.color: control.enabled ? SC.Theme.get("window.smartControl.buttons.normal.border.color") : SC.Theme.get("window.smartControl.buttons.disabled.border.color")
			radius: SC.Theme.get("window.smartControl.buttons.radius")
			Rectangle {
				anchors.top: parent.verticalCenter
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				color: control.enabled ? SC.Theme.get("window.smartControl.buttons.normal.border.bottom.color") : parent.color
				radius: parent.radius
			}

			Rectangle {
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.right: parent.right
				anchors.bottom: parent.bottom
				anchors.topMargin: 0.25*parent.height
				anchors.bottomMargin: 0.15*parent.height
				color: parent.color
			}
		}
		label: Text {
			text: control.text
			verticalAlignment: Text.AlignVCenter
			horizontalAlignment: Text.AlignHCenter
			color: control.enabled ? SC.Theme.get("window.smartControl.buttons.normal.label.color") : SC.Theme.get("window.smartControl.buttons.disabled.label.color")
			clip: true
			font.pixelSize: 0.5*control.height * font.pixelSize / contentHeight
			font.family: SC.Theme.get("window.smartControl.buttons.normal.label.font.family")
			font.weight: SC.Theme.get("window.smartControl.buttons.normal.label.font.weight")
		}
	}
}
