package gryffin.display;

import js.html.*;

import tannus.geom.*;
import tannus.ds.Stack;
import gryffin.display.Pixels;

import Math.*;
import tannus.math.TMath.*;

using tannus.math.TMath;
using gryffin.display.CtxTools;

class ChildContext extends Context {
	/* Constructor Function */
	public function new(ctx:CanvasRenderingContext2D, r:Rectangle):Void {
		super( ctx );

		rect = r;
	}

/* === Instance Methods === */

	/* erase the given Rectangle */
	override public function clearRect(x:Float, y:Float, w:Float, h:Float):Void {
		ctx.clearRect(modx(x), mody(y), w, h);
	}

	/* fill the given rect */
	override public function fillRect(x:Float, y:Float, w:Float, h:Float):Void {
		super.fillRect(modx(x), mody(y), w, h);
	}

	/* stroke the given Rect */
	override public function strokeRect(x:Float, y:Float, w:Float, h:Float):Void {
		super.strokeRect(modx(x), mody(y), w, h);
	}

	/**
	  * Draw the given text
	  */
	override public function fillText(text:String, x:Float, y:Float, ?maxWidth:Float):Void {
		super.filllText(text, modx( x ), mody( y ), maxWidth);
	}

	/* draw the outline of the given text */
	override public function strokeText(text:String, x:Float, y:Float, ?maxWidth:Float):Void {
		super.strokeText(text, modx(x), mody(y), maxWidth);
	}

	/* draw an Image onto [this] Context */
	override public function drawImage(image:Dynamic, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Float, dh:Float):Void {
		super.drawImage(image, sx, sy, sw, sh, modx(dx), mody(dy), dw, dh);
	}

	/* get the modified x-position */
	private inline function modx(x : Float):Float {
		return (rect.x + x);
	}

	/* get the modified y-position */
	private inline function mody(y : Float):Float {
		return (rect.y + y);
	}

	/* the width of [this] Context */
	override private function get_width():Int return floor( rect.width );
	override private function get_height():Int return floor( rect.height );

/* === Instance Fields === */

	/* the rectangle in which to draw things */
	public var rect : Rectangle;
}
