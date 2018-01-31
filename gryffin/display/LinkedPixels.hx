package gryffin.display;

import js.html.ImageData;
import js.html.Uint8Array;
import js.html.CanvasElement in Can;
import js.html.Uint8ClampedArray in UArray;

import tannus.graphics.Color;
import tannus.math.TMath;
import tannus.geom2.Point;
import tannus.geom2.Rect;
import tannus.ds.Maybe;
import tannus.io.ByteArray;

import Std.int;

class LinkedPixels extends CPixels {
	public function new(owner:Ctx, are:Rect<Float>, dat:ImageData):Void {
		super( dat );

		c = owner;
		area = are.floor();
	}

/* === Instance Methods === */

	override public function save():Void {
		c.putImageData(idata, 0, 0, area.x, area.y, area.w, area.h);
	}

/* === Instance Fields === */

	public var c : Ctx;
	public var area : Rect<Int>;
}
