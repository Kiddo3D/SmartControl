function setFontPixelSize(text, height) {
	text.font.pixelSize = Math.round(height * text.lineCount * text.font.pixelSize / text.contentHeight);
}

function fontWeight(weight) {
	switch(weight) {
		case "light": return Font.Light;
		case "normal": return Font.Normal;
		case "medium": return Font.DemiBold;
		default: throw "Font weight not found";
	}
}
