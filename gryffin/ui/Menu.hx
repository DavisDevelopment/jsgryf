package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.ds.Object;
import tannus.events.MouseEvent;
import tannus.graphics.Color;

using Lambda;

class Menu extends Entity {
	/* Constructor Function */
	public function new():Void {
		super();

		rect = new Rectangle();
		items = new Array();
		backgroundColor = '#515147';

		on('click', click);
	}

/* === Instance Methods === */

	/**
	  * Append a MenuItem to [this] Menu
	  */
	public function append(child : MenuItem):Void {
		if (!items.has( child )) {
			items.push( child );
			child.root = this;
		}
	}

	/**
	  * Render [this] Menu
	  */
	override public function render(s:Stage, c:Ctx):Void {
		c.save();

		// draw the background
		c.fillStyle = backgroundColor.toString();
		c.fillRect(x, y, w, h);

		// draw the menu-items
		for (item in items) {
			if ( item.enabled )
				item.render(s, c);
		}

		c.restore();
	}

	/**
	  * Update [this] Menu
	  */
	override public function update(s : Stage):Void {
		super.update( s );

		positionItems( s );
	}

	/**
	  * When [this] gets clicked
	  */
	private function click(e : MouseEvent):Void {
	}

	/**
	  * Position the items in [this] menu
	  */
	public function positionItems(s : Stage):Void {
		var ix:Float = 10;
		for (item in items) {
			item.update( s );
			if ( !item.enabled )
				continue;

			ix += item.padding.left;
			item.x = (x + ix);
			item.y = (y + ((h - item.h) / 2));
			ix += item.w;
			ix += item.padding.right;
		}
	}

	override public function containsPoint(p : Point):Bool {
		return rect.containsPoint( p );
	}

/* === Computed Instance Fields === */

	/* the 'x' position of [this] */
	public var x(get, set):Float;
	private function get_x():Float return rect.x;
	private function set_x(v : Float):Float return (rect.x = v);
	
	/* the 'y' position of [this] */
	public var y(get, set):Float;
	private function get_y():Float return rect.y;
	private function set_y(v : Float):Float return (rect.y = v);
	
	/* the width of [this] */
	public var w(get, set):Float;
	private function get_w():Float return rect.w;
	private function set_w(v : Float):Float return (rect.w = v);
	
	/* the height of [this] */
	public var h(get, set):Float;
	private function get_h():Float return rect.h;
	private function set_h(v : Float):Float return (rect.h = v);

	/* the position of [this] Menu, currently */
	public var pos(get, never):Point;
	private function get_pos():Point {
		return Point.linked(x, y);
	}

/* === Instance Fields === */

	public var rect : Rectangle;
	public var items : Array<MenuItem>;
	public var backgroundColor : Color;
}
