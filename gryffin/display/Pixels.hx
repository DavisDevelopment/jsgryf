package gryffin.display;

import js.html.ImageData;
import js.html.CanvasElement in Can;
import js.html.Uint8ClampedArray in UArray;

import tannus.graphics.Color;
import tannus.math.TMath;
import tannus.geom.Point;
import tannus.geom.Rectangle;
import tannus.ds.Maybe;

import Std.int;

class Pixels implements Paintable {
	/* Constructor Function */
	public function new(owner:Ctx, position:Point, dat:ImageData):Void {
		c = owner;
		idata = dat;
		data = idata.data;
		pos = position;
	}

/* === Instance Methods === */

	/**
	  * render [this] to a Canvas
	  */
	public function paint(c:Ctx, s:Rectangle, d:Rectangle):Void {
		c.putImageData(idata, s.x, s.y, d.x, d.y, d.w, d.h);
	}

	/**
	  * get a Pixel
	  */
	public inline function at(x:Float, y:Float):Pixel {
		return new Pixel(this, new Point(x, y));
	}

	/**
	  * get a Pixel by index
	  */
	public inline function ati(index : Int):Pixel {
		return new Pixel(this, new Point((index % width), (index / width)));
	}

	/**
	  * Get a Color
	  */
	public function getColor(xi:Float, ?y:Float):Color {
		if (y == null)
			return getAtIndex(int(xi));
		else
			return getAtPos(xi, y);
	}

	/**
	  * Get the Color at the given Point
	  */
	public inline function getAtPos(x:Float, y:Float):Color {
		return getAtIndex(index(x, y));
	}

	/**
	  * Get the Color at the given index
	  */
	public function getAtIndex(i : Int):Color {
		i *= 4;
		var col:Color = new Color(data[i], data[i+1], data[i+2], data[i+3]);
		return col;
	}

	/**
	  * Set the Color at the given index
	  */
	public function setAtIndex(i:Int, color:Color):Color {
		i *= 4;
		data[i] = color.red;
		data[i+1] = color.green;
		data[i+2] = color.blue;
		data[i+3] = (color.alpha!=null?color.alpha:0);
		return color;
	}

	/**
	  * Set the Color at the given Point
	  */
	public inline function setAtPos(x:Float, y:Float, color:Color):Color {
		return setAtIndex(index(x, y), color);
	}

	/**
	  * Set the Color at the given Point
	  */
	public function setColor(x:Float, y:Float, color:Color):Color {
		return setAtPos(x, y, color);
	}

	/* get the red chanel at the given pos */
	public inline function get_red(x:Float, y:Float):Int return data[(index(x, y) * 4)];
	public inline function get_green(x:Float, y:Float):Int return data[(index(x, y) * 4) + 1];
	public inline function get_blue(x:Float, y:Float):Int return data[(index(x, y) * 4) + 2];
	public inline function get_alpha(x:Float, y:Float):Int return data[(index(x, y) * 4) + 3];

	/* set the red channel at the given pos */
	public inline function set_red(x:Float, y:Float, val:Int):Int return (data[(index(x, y) * 4)] = val);
	public inline function set_green(x:Float, y:Float, val:Int):Int return (data[(index(x, y) * 4) + 1] = val);
	public inline function set_blue(x:Float, y:Float, val:Int):Int return (data[(index(x, y) * 4) + 2] = val);
	public inline function set_alpha(x:Float, y:Float, val:Int):Int return (data[(index(x, y) * 4) + 3] = val);

	/**
	  * Get index from position
	  */
	private inline function index(x:Float, y:Float):Int {
		return ((int(x) + int(y) * width));
	}

	/**
	  * get position from index
	  */
	private inline function coords(index : Int):tannus.ds.tuples.Tup2<Float, Float> {
		return new tannus.ds.tuples.Tup2((index % width)+0.0, (index / width));
	}

	/**
	  * Write [this] PixelData onto the given Canvas
	  */
	public function write(target:Ctx, x:Float, y:Float, sx:Float=0, sy:Float=0, ?sw:Maybe<Float>, ?sh:Maybe<Float>):Void {
		target.putImageData(idata, x, y, sx, sy, (sw || width), (sh || height));
	}

	/**
	  * Save [this] PixelData to the owner-canvas
	  */
	public function save():Void {
		write(c, pos.x, pos.y);
	}

	/**
	  * iterate over all Pixels in [this]
	  */
	public function iterator():PixelsIterator {
		return new PixelsIterator( this );
	}

/* === Computed Instance Fields === */

	public var width(get, never):Int;
	private inline function get_width() return idata.width;

	public var height(get, never):Int;
	private inline function get_height() return idata.height;

	public var length(get, never):Int;
	private inline function get_length() return int(data.length / 4);

/* === Instance Fields === */

	private var idata : ImageData;
	private var data : UArray;
	//private var canvas : Canvas;
	private var c : Ctx;
	private var pos : Point;
}

class PixelsIterator {
	public inline function new(p : Pixels) {
		src = p;
		ii = (0...p.length);
	}

	public inline function hasNext():Bool return ii.hasNext();
	public inline function next():Pixel return src.ati(ii.next());

	private var src : Pixels;
	private var ii : IntIterator;
}
