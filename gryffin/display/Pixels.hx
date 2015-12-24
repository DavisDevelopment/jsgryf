package gryffin.display;

import js.html.ImageData;
import js.html.CanvasElement in Can;
import js.html.Uint8ClampedArray in UArray;

import tannus.graphics.Color;
import tannus.math.TMath;
import tannus.geom.Point;
import tannus.ds.Maybe;

import Std.int;

class Pixels {
	/* Constructor Function */
	public function new(owner:Ctx, position:Point, dat:ImageData):Void {
		c = owner;
		idata = dat;
		data = idata.data;
		pos = position;
	}

/* === Instance Methods === */

	/**
	  * get a Pixel
	  */
	public inline function at(x:Float, y:Float):Pixel {
		return new Pixel(this, new Point(x, y));
	}

	/**
	  * Get a Color
	  */
	public function get(xi:Float, ?y:Float):Color {
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
	public function set(x:Float, y:Float, color:Color):Color {
		return setAtPos(x, y, color);
	}

	/**
	  * Get index from position
	  */
	private inline function index(x:Float, y:Float):Int {
		return ((int(x) + int(y) * width));
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
