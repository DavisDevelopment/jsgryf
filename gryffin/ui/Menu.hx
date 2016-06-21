package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.ds.Object;
import tannus.ds.Obj;
import tannus.events.MouseEvent;
import tannus.graphics.Color;
import tannus.math.TMath.*;

using Lambda;

class Menu extends Entity {
	/* Constructor Function */
	public function new():Void {
		super();

		rect = new Rectangle();
		items = new Array();
		backgroundColor = '#515147';
		orientation = Portrait;
	}

/* === Instance Methods === */

	/**
	  * initialize [this] Menu
	  */
	override public function init(stage : Stage):Void {
		_listen();
	}

	/**
	  * Create and append a new MenuItem
	  */
	public function item(options : Obj):MenuItem {
		var i = new MenuItem( options );
		append( i );
		return i;
	}

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
		var lg = gradient( c );
		c.fillStyle = lg;
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
	  * Make the gradient used to fill [this] Menu
	  */
	private function gradient(c : Ctx):js.html.CanvasGradient {
		var amount:Float = 8;
		var start:Color = backgroundColor.lighten(amount - 2);
		var end:Color = backgroundColor.darken(amount + 1);
		var lg = c.createLinearGradient(x, y, x, (y+h));
		lg.addColorStop(0.0, start.toString());
		lg.addColorStop(1.0, end.toString());

		return lg;
	}

	/**
	  * Get all items attached to [this], and their descendents, recursively
	  */
	private function walk(?list:Array<MenuItem>):Array<MenuItem> {
		if (list == null)
			list = items;
		var results:Array<MenuItem> = new Array();
		for (item in list) {
			results.push( item );
			results = results.concat(walk(item.items));
		}
		return results;
	}

	/**
	  * When [this] gets clicked
	  */
	public function itemClicked(item : MenuItem):Void {
		if ( !item.subMenu ) {
			for (i in walk()) {
				i.showChildren = false;
			}
		}
	}

	/**
	  * close all sub-menus
	  */
	public function closeAll():Void {
		for (item in items) {
			item.close();
		}
	}

	/**
	  * determine whether any sub-menu is currently open
	  */
	public function isAnyOpen():Bool {
		for (i in items) {
			if ( i.showChildren ) {
				return true;
			}
		}
		return false;
	}

	/**
	  * Position the items in [this] menu
	  */
	public function positionItems(s : Stage):Void {
		var ix:Float = 10;
		var iy:Float = 0;
		var itm:Null<MenuItem> = null;
		var maxw:Float = 0;
		for (item in items) {
			item.update( s );
			itm = item;
			if ( !item.enabled )
				continue;
			
			switch (orientation) {
				case Portrait:
					ix += item.padding.left;
					item.x = (x + ix);
					item.y = (y + ((h - item.h) / 2));
					maxw = max(item.w, maxw);
					ix += item.w;
					ix += item.padding.right;

				case Landscape:
					iy += item.padding.top;
					item.x = (x + ix + ((w - item.w) / 2));
					item.y = (y + iy);
					maxw = max(item.w, maxw);
					iy += item.h;
					iy += item.padding.bottom;
			}
		}

		if (orientation == Landscape && itm != null) {
			h = iy;
			w = maxw;
		}
	}

	override public function containsPoint(p : Point):Bool {
		return rect.containsPoint( p );
	}

	private function _listen():Void {
		stage.on('click', function(event) {
			if (!containsPoint( event.position )) {
				for (item in items) {
					if (item.hierarchyContainsPoint( event.position )) {
						return ;
					}
				}
				closeAll();
			}
		});
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
	public var orientation : Orientation;
}
