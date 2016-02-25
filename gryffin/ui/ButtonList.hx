package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.events.MouseEvent;

import Math.*;
import Std.*;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class ButtonList extends List<ButtonListItem> {
	/* Constructor Function */
	public function new():Void {
		super();

		target = new Point();
		cols = 1;
		curcol = 1;
		currow = 0;
		width = 0;
		height = 0;
	}

/* === Instance Methods === */

	/**
	  * add a Button to [this] List
	  */
	public inline function button(text:String, onclick:MouseEvent->Void):ButtonListItem {
		return addButton({
			'text': text,
		       	'click': onclick
		});
	}

	/**
	  * add a Button to [this] List
	  */
	public inline function addButton(button : Button):ButtonListItem {
		var li = new ButtonListItem( button );
		addItem( li );
		return li;
	}

	/**
	  * get the Point which acts as the starting Point for item positioning
	  */
	override public function firstPos():Point {
		return target.clone();
	}

	/**
	  * position the Buttons
	  */
	override private function positionItems(stage : Stage):Void {
		curcol = 1;
		currow = 0;
		var fp = firstPos();
		row = new Rectangle(fp.x, fp.y, 0, 0);
		super.positionItems( stage );
	}

	/**
	  * position a single Button
	  */
	override public function positionItem(p:Point, b:ButtonListItem):Void {
		if (curcol == cols) {
			p.y = rowy();
			
			curcol = 1;
			currow++;

			p.x += b.margin.left;
			p.y += b.margin.top;
			b.x = p.x;
			b.y = p.y;
			p.y += b.h;
			p.y += b.margin.bottom;
			p.x += b.margin.right;

			var rowi:Int = (currow - 1);
			if (rows[rowi] == null) {
				rows.push( row );
			}
			else {
				rows[rowi] = row;
			}
			var fp = firstPos();
			row = new Rectangle(fp.x, fp.y, 0, 0);
		}
		else {
			curcol++;
			var r = (rows[currow] == null ? row : rows[currow]);
			p.y = rowy();
			
			p.x += b.margin.left;
			p.y += b.margin.top;
			b.x = p.x;
			b.y = p.y;
			p.x += b.w;
			p.x += b.margin.right;
			p.y += b.margin.bottom;

			r.w += (b.margin.horizontal + b.w);
			r.h = max(r.h, (b.margin.vertical + b.h));
		}

		width = (p.x - target.x);
		height = (p.y - target.y);
	}

	/**
	  * get the y-offset of the current row
	  */
	private function rowy():Float {
		return (target.y + rows.slice(0, currow).macsum(_.height));
	}

	/**
	  * check whether [this] contains the given Point
	  */
	override public function containsPoint(p : Point):Bool {
		for (i in items) {
			if (i.containsPoint( p )) {
				return true;
			}
		}
		return false;
	}

/* === Instance Fields === */

	public var target : Point;
	public var width : Float;
	public var height : Float;
	public var cols : Int;

	private var curcol : Int;
	private var currow : Int;
	private var row : Rectangle;
	private var rows : Array<Rectangle> = {new Array();};
}
