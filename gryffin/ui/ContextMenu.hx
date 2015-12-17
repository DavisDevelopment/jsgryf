package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.math.TMath.*;
import tannus.graphics.Color;
import tannus.events.MouseEvent;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class ContextMenu extends List<ContextMenuItem> {
	/* Constructor Function */
	public function new():Void {
		super();

		max_width = 0;
		target = new Point();

		on('click', click);
	}

/* === Instance Methods === */

	/* the starting position */
	override public function firstPos():Point {
		return target.clone();
	}

	/* move an item */
	override public function positionItem(p:Point, item:ContextMenuItem):Void {
		item.y = p.y;
		item.x = p.x;
		p.y += item.h;
		max_width = max(max_width, item.w);
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
		c.rect(target.x, target.y, max_width, contentHeight());
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
	public function item(data : Dynamic):ContextMenuItem {
		var mitem:ContextMenuItem = new ContextMenuItem(this, data);
		addItem( mitem );
		return mitem;
	}

	/**
	  * add a button to [this] Menu
	  */
	public function button(text:String, cb:Void->Void):ContextMenuItem {
		return item({
			'label': text,
			'click': cb
		});
	}

/* === Instance Fields === */

	public var max_width : Float;
	public var target : Point;
}
