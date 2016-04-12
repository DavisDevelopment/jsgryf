package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.geom.Point;

@:access( gryffin.ui.List )
class ListItem extends Entity {
	/* Constructor Function */
	public function new():Void {
		super();
		x = 0;
		y = 0;
		w = 0;
		h = 0;
	}

/* === Instance Methods === */

	/**
	  * whether the given Point lies within the rectangle that [this] occupies
	  */
	override public function containsPoint(p : Point):Bool {
		return rect.containsPoint( p );
	}

	/**
	  * reflow the layout
	  */
	private function reflow():Void {
		if (list != null) {
			list.altered = true;
		}
	}

	/**
	  * update [this] ListItem, in response to it's containing List updating
	  */
	public function updateListItem(stage : Stage):Void {
		null;
	}

	/**
	  * update [this] ListItem
	  */
	override public function update(stage : Stage):Void {
		super.update( stage );

		if ( altered ) {
			list.altered = true;
			altered = false;
		}
	}

/* === Computed Instance Fields === */

	/* the 'x' position of [this] Item */
	public var x(get, set):Float;
	private function get_x():Float return _x;
	private function set_x(v : Float):Float return (_x = v);

	/* the 'y' position of [this] Item */
	public var y(get, set):Float;
	private function get_y():Float return _y;
	private function set_y(v : Float):Float return (_y = v);

	/* the width of [this] Item */
	public var w(get, set):Float;
	private function get_w():Float return _w;
	private function set_w(v : Float):Float return (_w = v);
	
	/* the height of [this] Item */
	public var h(get, set):Float;
	private function get_h():Float return _h;
	private function set_h(v : Float):Float return (_h = v);

	/* the position of [this] Item */
	public var pos(get, never):Point;
	private inline function get_pos():Point {
		return Point.linked(x, y);
	}

	/* the rectangle which [this] Item occupies */
	public var rect(get, never):Rectangle;
	private function get_rect():Rectangle {
		return new Rectangle(x, y, w, h);
	}

	/* the containing List */
	public var list(get, never):Null<List<ListItem>>;
	private inline function get_list():Null<List<ListItem>> {
		return cast parentUntil(function(e) return Std.is(e, List));
	}

/* === Instance Fields === */

	private var _x : Float;
	private var _y : Float;
	private var _w : Float;
	private var _h : Float;
	private var altered : Bool = false;
}
