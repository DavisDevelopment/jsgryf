package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.graphics.Color;

using Lambda;
using tannus.ds.ArrayTools;

class Tooltip extends Entity {
	/* Constructor Function */
	public function new():Void {
		super();

		target = new Rectangle();
		box = new TextBox();
		padding = new Padding();
		margin = 0;
		direction = Left;

		textColor = '#000';
		backgroundColor = '#FFF';
		borderColor = '#676767';
		borderWidth = 1;
		borderRadius = 0;
	}

/* === Instance Methods  === */

	/**
	  * Initialize [this] Tooltip
	  */
	override public function init(s : Stage):Void {
		super.init( s );

		padding.vertical = 2;
		padding.horizontal = 2;

		box.fontFamily = 'Ubuntu';
		box.fontSize = 10;
	}

	/**
	  * Render [this] Tooltip
	  */
	override public function render(s:Stage, c:Ctx):Void {
		var r = rect;
		
		c.save();
	
		c.beginPath();
		c.strokeStyle = borderColor.toString();
		c.lineWidth = borderWidth;
		c.fillStyle = backgroundColor.toString();
		c.roundRect(r.x, r.y, r.w, r.h, borderRadius);
		c.closePath();
		c.fill();
		c.stroke();
		drawTail(r, s, c);
	
		c.restore();

		var tr = new Rectangle(0, 0, box.width, box.height);
		tr.center = r.center;

		c.drawComponent(box, 0, 0, tr.w, tr.h, tr.x, tr.y, tr.w, tr.h);
	}

	/**
	  * Draw the tail-thingy for [this] Tooltip
	  */
	private function drawTail(r:Rectangle, s:Stage, c:Ctx):Void {
		var tw:Float = 0;
		var mp:Point = new Point();
		var tri:Triangle = new Triangle();
		switch ( direction ) {
			case Left:
				tw = (0.45 * r.h);
				mp.copyFrom(new Point((r.x + r.w), r.centerY));
				tri.points.each(_.copyFrom( mp ));
				tri.one.y -= (tw/2);
				tri.two.y += (tw/2);
				tri.three.x += tw;

			case Right:
				tw = (0.45 * r.h);
				mp.copyFrom(new Point(r.x, r.centerY));
				tri.points.each(_.copyFrom(mp));
				tri.one.y -= (tw/2);
				tri.two.y += (tw/2);
				tri.three.x -= tw;

			case Top:
				tw = (0.55 * r.h);
				mp.copyFrom(new Point(r.centerX, r.y));
				tri.points.each(_.copyFrom( mp ));
				tri.two.x -= (tw/2);
				tri.three.x += (tw/2);
				tri.one.y -= tw;

			case Bottom:
				tw = (0.55 * r.h);
				mp.copyFrom(new Point(r.centerX, (r.y + r.h)));
				tri.points.each(_.copyFrom( mp ));
				tri.two.x -= (tw/2);
				tri.three.x += (tw/2);
				tri.one.y += tw;

			default:
				throw 'fuck you';
		}

		c.strokeStyle = borderColor.toString();
		c.lineWidth = borderWidth;
		c.fillStyle = backgroundColor.toString();
		c.beginPath();
		c.moveTo(tri.one.x, tri.one.y);
		c.lineTo(tri.three.x, tri.three.y);
		c.lineTo(tri.two.x, tri.two.y);
		c.closePath();
		c.fill();
		c.stroke();
		
		switch (direction) {
			case Left, Right:
				c.fillRect(tri.one.x-1, tri.one.y, c.lineWidth+1, (tri.two.y - tri.one.y - 1));
			case Top, Bottom:
				c.fillRect(tri.two.x, tri.two.y-1, (tri.three.x - tri.two.x - 1), c.lineWidth+1);
		}
	}

/* === Computed Instance Fields === */

	/* the x-position of our target */
	public var x(get, set):Float;
	private inline function get_x():Float return target.x;
	private inline function set_x(v : Float):Float return (target.x = v);
	
	/* the y-position of our target */
	public var y(get, set):Float;
	private inline function get_y():Float return target.y;
	private inline function set_y(v : Float):Float return (target.y = v);

	/* the textual content of [this] Tooltip */
	public var text(get, set):String;
	private inline function get_text():String return box.text;
	private inline function set_text(v : String):String return (box.text = v);

	/* the content-rectangle */
	public var rect(get, never):Rectangle;
	private function get_rect():Rectangle {
		var r = new Rectangle();
		r.w = (box.width + padding.horizontal);
		r.h = (box.height + padding.vertical);
		switch ( direction ) {
			case Left:
				r.x = (target.x - r.w - margin - tailSize);
				r.centerY = target.centerY;

			case Right:
				r.x = (target.x + target.w + margin + tailSize);
				r.centerY = target.centerY;

			case Top:
				r.centerX = target.centerX;
				r.y = (target.y + target.h + margin + tailSize);

			case Bottom:
				r.centerX = target.centerX;
				r.y = (target.y - r.h - margin - tailSize);
		}
		return r;
	}

	/* the length of [this]'s "tail" */
	private var tailSize(get, never):Float;
	private function get_tailSize():Float {
		return ((switch( direction ) {
			case Left, Right: 0.45;
			case Bottom, Top: 0.55;
		}) * (box.height + padding.vertical));
	}

	/* the color of [this] Tooltip's text */
	public var textColor(get, set):Color;
	private inline function get_textColor():Color return box.color;
	private inline function set_textColor(v : Color):Color return (box.color = v);

/* === Instance Fields === */

	public var direction : Direction;
	public var padding : Padding;
	public var margin : Float;
	public var target : Rectangle;
	public var box : TextBox;

	public var backgroundColor : Color;
	public var borderColor : Color;
	public var borderWidth : Float;
	public var borderRadius : Float;
}
