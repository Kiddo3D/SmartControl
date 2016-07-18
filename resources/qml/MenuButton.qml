import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.1

import SC 1.0 as SC
import "util.js" as Util

Button {
	property color borderColor
	anchors.left: parent.left
	anchors.right: parent.right
	Image {
		id: icon
		source: iconSource
		fillMode: Image.PreserveAspectFit
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.bottom: parent.bottom
		anchors.topMargin: 0.1*parent.height
		anchors.bottomMargin: anchors.topMargin
		anchors.leftMargin: 2*anchors.topMargin
		anchors.rightMargin: anchors.leftMargin
	}
	style: ButtonStyle {
		background: Rectangle {
			color: control.pressed || control.checked ? SC.Theme.get("window.menu.items.color.pressed") : SC.Theme.get("window.menu.items.color.normal")
			Rectangle {
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				width: 0.02*parent.width
				color: borderColor
			}
		}
		label: Text {
			text: control.text
			anchors.left: parent.left
			anchors.leftMargin: icon.width + icon.anchors.leftMargin + icon.anchors.leftMargin
			verticalAlignment: Text.AlignVCenter
			color: SC.Theme.get("window.menu.items.label.color")
			clip: true
			font.family: SC.Theme.get("window.menu.items.label.font.family")
			font.weight: Util.fontWeight(SC.Theme.get("window.menu.items.label.font.weight"))
			onWidthChanged: Util.setFontPixelSize(this, 0.45*control.height)
			Component.onCompleted: Util.setFontPixelSize(this, 0.45*control.height)
  		}
	}
	Component.onCompleted: __behavior.cursorShape = Qt.PointingHandCursor
}
