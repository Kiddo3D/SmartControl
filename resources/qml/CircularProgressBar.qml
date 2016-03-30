import QtQuick 2.2

import SC 1.0 as SC
import "util.js" as Util

Rectangle {
	id: container
	state: "IN_PROGRESS"
	property int progress: 0
	onProgressChanged: {
		state = progress < 100 ? "IN_PROGRESS" : "FINISHED"
		bar.requestPaint()
	}
	width: parent.width
	height: parent.width
	border.width: 0.015*width
	radius: width
	Canvas {
		id: bar
		anchors.fill: parent
		onPaint: {
			var context = getContext("2d");
			if (parent.state == "IN_PROGRESS") {
				context.beginPath();
				context.lineWidth = 0.07*width;
				context.strokeStyle = SC.Theme.get("window.smartControl.progressBar.inProgress.bar.color");
				var startAngle = -0.5*Math.PI;
				context.arc(width/2, height/2, width/2 - context.lineWidth, startAngle, (parent.progress/100) * -2*Math.PI + startAngle, true);
				context.stroke();
			} else {
				context.reset();
			}
		}
	}

	Text {
		id: text
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.verticalCenter: parent.verticalCenter
		horizontalAlignment: Text.AlignHCenter
		font.family: SC.Theme.get("window.smartControl.progressBar.text.font.family")
		font.weight: Util.getFontWeight(SC.Theme.get("window.smartControl.progressBar.text.font.weight"))
		Component.onCompleted: Util.setFontPixelSize(this, 0.35*parent.height)
		onWidthChanged: Util.setFontPixelSize(this, 0.35*parent.height)
	}
	states: [
		State {
			name: "IN_PROGRESS"
			PropertyChanges { target: container; color: SC.Theme.get("window.smartControl.progressBar.inProgress.color"); border.color: SC.Theme.get("window.smartControl.progressBar.inProgress.border.color") }
			PropertyChanges { target: text; text: parent.progress + "%"; color: SC.Theme.get("window.smartControl.progressBar.inProgress.text.color") }
		},
		State {
			name: "FINISHED"
			PropertyChanges { target: container; color: SC.Theme.get("window.smartControl.progressBar.finished.color"); border.color: SC.Theme.get("window.smartControl.progressBar.finished.border.color") }
			PropertyChanges { target: text; text: "OK"; color: SC.Theme.get("window.smartControl.progressBar.finished.text.color") }
		}
	]

	transitions: [
		Transition {
			from: "IN_PROGRESS"
			to: "FINISHED"
			ColorAnimation { target: container; duration: SC.Theme.get("window.smartControl.progressBar.finished.animation.duration") }
			ColorAnimation { target: text; duration: 0 }
		}
	]
}
