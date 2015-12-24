package gryffin.display;

import gryffin.display.*;

import tannus.geom.*;
import tannus.graphics.Color;
import tannus.io.Ptr;

@:access(gryffin.display.Pixels)
class Pixel {
	/* Constructor Function */
	public function new(s:Pixels, p:Point):Void {
		src = s;
		pos = p;
	}

/* === Computed Instance Fields === */

	/* the color of [this] Pixel */
	public var color(get, set):Color;
	private inline function get_color():Color {
		return src.getAtPos(pos.x, pos.y);
	}
	private inline function set_color(v : Color):Color {
		return src.setAtPos(pos.x, pos.y, v);
	}

/* === Instance Fields === */

	private var src : Pixels;
	private var pos : Point;
}
