package gryffin.display;

/*
#if !macro
import js.html.ImageData;
import js.html.Uint8Array;
import js.html.CanvasElement in Can;
import js.html.Uint8ClampedArray in UArray;
#end
*/

import tannus.graphics.Color;
import tannus.math.TMath;
import tannus.geom.Point;
import tannus.geom.Rectangle;
import tannus.ds.Maybe;
import tannus.io.ByteArray;

import Std.int;

class CPixels #if !macro implements Paintable #end {
	/* Constructor Function */
	/*
	public function new(owner:Ctx, position:Point, dat:ImageData):Void {
	*/
	public function new(dat : ImageData):Void {
		// c = owner;
		idata = dat;
		data = idata.data;
		// pos = position;
	}

/* === Instance Methods === */

#if !macro
	/**
	  * render [this] to a Canvas
	  */
	public function paint(c:Ctx, s:Rectangle, d:Rectangle):Void {
		c.putImageData(idata, s.x, s.y, d.x, d.y, d.w, d.h);
	}

	/**
	  * Create and return a copy of [this] that is linked to the given Canvas, at a given Point
	  */
	public function link(context:Ctx, area:Rectangle):Pixels {
		return new LinkedPixels(context, area, imageData);
	}

#end

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
#if !macro
	public function write(target:Ctx, x:Float, y:Float, sx:Float=0, sy:Float=0, ?sw:Maybe<Float>, ?sh:Maybe<Float>):Void {
		target.putImageData(idata, x, y, sx, sy, (sw || width), (sh || height));
	}
	public function save():Void {
		null;
	}
#end

	/**
	  * Save [this] PixelData to the owner-canvas
	  */
	/*
	public function save():Void {
		write(c, pos.x, pos.y);
	}
	*/

	/**
	  * iterate over all Pixels in [this]
	  */
	public function iterator():PixelsIterator {
		return new PixelsIterator( this );
	}

	/**
	  * Get the underlying ImageData object
	  */
	public inline function getData():ImageData {
		return idata;
	}

	/**
	  * Store [this] into a ByteArray, which can be read back into an ImageData
	  */
	public function toByteArray():ByteArray {
		// create a clone of [idata]
		/*
		var idc = {
			width  : idata.width,
			height : idata.height,
			data   : idata.data.subarray(0, (idata.data.length - 1))
		};
		*/

		// pull the entirety of the ImageData onto [data]
		var data:ByteArray = ByteArray.ofData(untyped idata.data.buffer);
		data.shiftRight( 2 );
		data.seek( 0 );
		data.writeByte( idata.width );
		data.writeByte( idata.height );
		trace( data.length );
		return data;
	}

	/**
	  * iterate over every [jump]th Pixel
	  */
	public function skim(jump : Int):PixelsIterator {
		return new PixelsIterator(this, jump);
	}

	/**
	  * get the averaged Color of [this] entire Pixel array
	  */
	public function getAverageColor():Color {
		var c:Null<Color> = null;
		for (pixel in this.skim( 25 )) {
			if (c == null) {
				c = pixel.color;
			}
			else {
				c = c.mix(pixel.color, 50);
			}
		}
		return c;
	}

/* === Computed Instance Fields === */

	public var width(get, never):Int;
	private inline function get_width() return idata.width;

	public var height(get, never):Int;
	private inline function get_height() return idata.height;

	public var length(get, never):Int;
	private inline function get_length() return int(data.length / 4);

	public var imageData(get, never):ImageData;
	private inline function get_imageData():ImageData return idata;

/* === Instance Fields === */

	private var idata : ImageData;
	private var data : UArray;
	//----------------------------
	//private var canvas : Canvas;
	//private var c : Ctx;
	//private var pos : Point;

/* === Static Methods === */

#if !macro

	/**
	  * Build a Pixels object from a ByteArray
	  */
	public static function fromByteArray(b : ByteArray):Pixels {
		return new Pixels(imageDataFromByteArray( b ));
	}

	/**
	  * Build an ImageData object from a ByteArray
	  */
	public static inline function imageDataFromByteArray(b : ByteArray):ImageData {
		return new ImageData(cast b.sub(2, (b.length - 2)).getData(), b[0], b[1]);
		/*
		var w:Int = b.readByte();
		var h:Int = b.readByte();
		var d:UArray = new UArray(b.read(b.length - b.position).getData());

		var id = new ImageData(d, w, h);
		*/
	}
#end
}

@:access( gryffin.display.Pixels )
class PixelsIterator {
	public function new(p:Pixels, j:Int=1) {
		src = p;
		i = 0;
		step = j;
	}

	public function hasNext():Bool {
		return (i < src.length);
	}

	public function next():Pixel {
		var _i:Int = i;
		i += step;
		return src.ati( _i );
	}

	private var src : Pixels;
	private var i : Int;
	private var step : Int;
}

#if !macro

typedef UArray = js.html.Uint8ClampedArray;
typedef ImageData = js.html.ImageData;

#else

private typedef Ctx = Dynamic;
typedef UArray = Array<Int>;
typedef ImageData = {
	var width : Int;
	var height : Int;
	var data : UArray;
};

#end
