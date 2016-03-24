package gryffin.ui;

import tannus.geom.Position;

class Padding extends Position {
/* === Instance Methods === */

	/**
	  * copy data from the given position to [this]
	  */
	public function copyFrom(other : Position):Void {
		left = other.left;
		right = other.right;
		bottom = other.bottom;
		top = other.top;
	}

/* === Computed Instance Fields === */

	/* the horizontal padding */
	public var horizontal(get, set):Float;
	private inline function get_horizontal():Float return (left + right);
	private function set_horizontal(v : Float):Float {
		left = v;
		right = v;
		return v;
	}

	/* the vertical padding */
	public var vertical(get, set):Float;
	private inline function get_vertical():Float return (top + bottom);
	private function set_vertical(v : Float):Float {
		top = v;
		bottom = v;
		return v;
	}

	/* the padding for every side */
	public var all(get, set):Float;
	private inline function get_all():Float {
		return left;
	}
	private inline function set_all(v : Float):Float {
		return (left = right = bottom = top = v);
	}
}
