package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;

import Math.*;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class LayoutRow {
	/* Constructor Function */
	public function new():Void {
		cols = new Array();
		manager = null;
	}

/* === Instance Methods === */

	/**
	  * Add an Element to [this] Row
	  */
	public function addElement(elem : LayoutElement):Void {
		cols.push( elem );
		modified = true;
	}

	/**
	  * remove an Element from [this] Row
	  */
	public function removeElement(elem : LayoutElement):Bool {
		var had = cols.remove( elem );
		modified = true;
		return had;
	}

	/* check whether [this] Row contains the given Row */
	public inline function hasElement(elem : LayoutElement):Bool {
		return cols.has( elem );
	}

	/**
	  * Get what the metrics would be with the given Element added
	  */
	public function previewWithElement(elem : LayoutElement):Rectangle {
		cols.push( elem );
		var res = new Rectangle(0, 0, width, height);
		cols.pop();
		return res;
	}

	/* get the previous Row */
	public function previousRow():Null<LayoutRow> {
		if (manager != null) {
			return manager.rowBefore( this );
		}
		else {
			return null;
		}
	}

	/* get the next Row */
	public function nextRow():Null<LayoutRow> {
		if (manager != null) {
			return manager.rowAfter( this );
		}
		else {
			return null;
		}
	}

	/* get the position of [this] Row */
	public function getPosition():Point {
		var pos = new Point(0, 0);
		var pr = previousRow();
		if (pr != null) {
			pos.y = (pr.pos.y + pr.height);
		}
		modified = false;
		return pos;
	}

/* === Computed Instance Fields === */

	/* the total width of [this] Row */
	public var width(get, never):Float;
	private function get_width():Float {
		return cols.macsum( _.w );
	}

	/* the height of [this] Row */
	public var height(get, never):Float;
	private function get_height():Float {
		return cols.macmaxe( _.h );
	}

	/* the number of elements in [this] Row */
	public var length(get, never):Int;
	private inline function get_length():Int return cols.length;

	public var empty(get, never):Bool;
	private inline function get_empty():Bool return (length == 0);

	/* index of [this] Row */
	public var index(get, never):Int;
	private inline function get_index():Int {
		return  if (manager != null) manager.getRowIndex( this )
			else -1;
	}

	/* the position of [this] Row */
	public var pos(get, never):Point;
	private function get_pos():Point {
		if (_pos == null || modified) {
			_pos = getPosition();
		}
		return _pos;
	}

/* === Instance Fields === */

	/* the list of Elements on [this] Row */
	public var cols : Array<LayoutElement>;

	/* the LayoutManager to which [this] is attached */
	public var manager : Null<LayoutManager>;

	/* the position of [this] Row */
	private var _pos : Null<Point> = null;
	private var modified : Bool = false;
}
