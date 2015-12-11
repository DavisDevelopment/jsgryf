package gryffin.ui;

import tannus.graphics.Color;

class Border {
	/* Constructor Function */
	public function new(size:Float=0, ?colr:Color):Void {
		width = size;
		radius = 0;
		color = new Color(0, 0, 0);
	}

/* === Instance Methods === */

	/**
	  * Convert [this] to a String
	  */
	public function toString():String {
		return 'Border(width=$width, color=$color)';
	}

/* === Instance Fields === */

	public var width : Float;
	public var color : Color;
	public var radius : Float;
}
