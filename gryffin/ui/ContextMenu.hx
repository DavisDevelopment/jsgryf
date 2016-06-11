package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.math.TMath.*;
import tannus.graphics.Color;
import tannus.events.MouseEvent;
import tannus.io.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class ContextMenu extends List<ContextMenuItem> {
	/* Constructor Function */
	public function new():Void {
		super();

		max_width = 0;
		total_height = 0;
		targetX = 0;
		targetY = 0;
		tar = Point.linked(targetX, targetY);
		viewport = get_vp;

		on('click', click);
	}

/* === Instance Methods === */

	/* the starting position */
	override public function firstPos():Point {
		var t = target.clone();
		if ( goup )
			t.y -= contentHeight();
		return t;
	}

	/* move an item */
	override public function positionItem(p:Point, item:ContextMenuItem):Void {
		item.y = p.y;
		item.x = p.x;
		p.y += item.h;
		max_width = max(max_width, item.w);
		total_height = (item.y + item.h);
	}

	override public function positionItems(stage : Stage):Void {
		total_height = 0;
		super.positionItems( stage );

		var mr = new Rectangle(max_width, total_height);
		var contained = inRect(mr, viewport.get());
		if (!goup && !contained) {
			goup = true;
			altered = true;
		}
		else if (goup && !contained) {
			goup = false;
			altered = true;
		}
	}

	/**
	  * Check whether [x] is completely inside [y]
	  */
	private function inRect(x:Rectangle, y:Rectangle):Bool {
		for (r in x.corners) {
			if (!y.containsPoint( r )) {
				return false;
			}
		}
		return true;
	}

	/* get the total height of the content */
	private function contentHeight():Float {
		return items.macmap( _.h ).sum();
	}

	/* render [this] menu */
	override public function render(s:Stage, c:Ctx):Void {
		c.beginPath();
		c.fillStyle = '#FFFFCC';
		c.shadowColor = '#666666';
		c.shadowOffsetX = 5;
		c.shadowOffsetY = 5;
		c.shadowBlur = 15;
		var rect:Rectangle = new Rectangle(target.x, target.y, max_width, contentHeight());
		if ( goup ) {
			rect.y -= contentHeight();
		}
		c.drawRect( rect );
		c.closePath();
		c.fill();

		super.render(s, c);
	}

	/* check whether a given Point lies within our content rect */
	override public function containsPoint(p : Point):Bool {
		var cr = new Rectangle(target.x, target.y, max_width, contentHeight());
		return cr.containsPoint( p );
	}

	/* when [this] menu receives a click event */
	public function click(e : MouseEvent):Void {
		trace( e );
	}

	/**
	  * add an item to [this] menu
	  */
	public function item(btn : Button):ContextMenuItem {
		var mitem:ContextMenuItem = new ContextMenuItem(this, btn);
		addItem( mitem );
		return mitem;
	}

	/**
	  * add a button to [this] Menu
	  */
	public function button(text:String, cb:MouseEvent -> Void):ContextMenuItem {
		return item({
			'text': text,
			'click': cb
		});
	}

/* === Computed Instance Fields === */

	/* the point from  which to position [this] */
	public var target(get, set) : Point;
	private inline function get_target():Point return tar;
	private function set_target(v : Point):Point {
		tar.copyFrom( v );
		altered = true;
		return tar;
	}

	private var targetX(default, set): Float;
	private function set_targetX(v : Float):Float {
		targetX = v;
		altered = true;
		return targetX;
	}

	private var targetY(default, set): Float;
	private function set_targetY(v : Float):Float {
		targetY = v;
		altered = true;
		return targetY;
	}

	private function get_vp():Rectangle {
		if (stage == null) {
			return new Rectangle();
		}
		else {
			return stage.rect;
		}
	}

/* === Instance Fields === */

	public var max_width : Float;
	public var total_height : Float;

	/* the underlying LinkedPoint instance for [target] */
	private var tar : Point;

	/* the viewport for the direction */
	public var viewport : Getter<Rectangle>;

	/* whether items should be positioned above or below [target] */
	private var goup : Bool = false;
}
