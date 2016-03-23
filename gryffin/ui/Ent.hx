package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;

class Ent extends EntityContainer {
	/* Constructor Function */
	public function new():Void {
		super();

		rect = new Rectangle();
	}

/* === Instance Methods === */

	/**
	  * Check whether the given Point is 'inside' [rect]
	  */
	override public function containsPoint(p : Point):Bool {
		return (rect.containsPoint( p ));
	}

/* === Computed Instance Fields === */

	/* the 'x' position of [this] */
	public var x(get, set):Float;
	private inline function get_x():Float return rect.x;
	private inline function set_x(v : Float):Float return (rect.x = v);
	
	/* the 'y' position of [this] */
	public var y(get, set):Float;
	private inline function get_y():Float return rect.y;
	private inline function set_y(v : Float):Float return (rect.y = v);
	
	/* the width of [this] */
	public var w(get, set):Float;
	private function get_w():Float return rect.w;
	private function set_w(v : Float):Float return (rect.w = v);
	
	/* the height of [this] */
	public var h(get, set):Float;
	private function get_h():Float return rect.h;
	private function set_h(v : Float):Float return (rect.h = v);

	/* the position of [this], as a Point */
	public var pos(get, set):Point;
	private function get_pos():Point {
		return Point.linked(x, y);
	}
	private function set_pos(v : Point):Point {
		return new Point(x=v.x, y=v.y);
	}

	/* the center of [this] along the x-axis */
	public var centerX(get, set):Float;
	private function get_centerX():Float {
		return (x + (w / 2));
	}
	private function set_centerX(v : Float):Float {
		return (x = (v - (w / 2)));
	}

	/* the center of [this] along the y-axis */
	public var centerY(get, set):Float;
	private function get_centerY():Float {
		return (y + (w / 2));
	}
	private function set_centerY(v : Float):Float {
		return (y = (v - (h / 2)));
	}

	/* the center of [this] */
	public var center(get, set):Point;
	private function get_center():Point return Point.linked(centerX, centerY);
	private function set_center(v : Point):Point return (rect.center = v);

/* === Instance Fields === */

	public var rect : Rectangle;
}
