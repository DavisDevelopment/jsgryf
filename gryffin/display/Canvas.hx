package gryffin.display;

import tannus.ds.Ref;
import tannus.geom.*;
import tannus.io.ByteArray;
import tannus.io.Blob;
import tannus.html.Blobable;

import gryffin.display.Ctx;
import gryffin.display.Context;
import gryffin.display.Paintable;

import js.html.CanvasElement in NCanvas;
import js.Browser.document in doc;
import js.html.Blob in JBlob;
import js.html.FileReader;

import Math.*;
import tannus.math.TMath.*;

class Canvas implements BitmapSource implements Blobable {
	/* Constructor Function */
	public function new(?c:NCanvas):Void {
		if (c != null)
			canvas = c;
		else
			canvas = doc.createCanvasElement();
		_ctx = Ref.create(new Ctx(canvas.getContext2d()));
	}

/* === Instance Methods === */

	/**
	  * Create and return a perfect clone of [this] Canvas
	  */
	public function clone():Canvas {
		var c:NCanvas = cast canvas.cloneNode();
		return new Canvas( c );
	}

	/**
	  * Resize [this] Canvas
	  */
	public function resize(w:Int, h:Int):Void {
		canvas.width = w;
		canvas.height = h;
		_ctx = Ref.create(new Ctx(canvas.getContext2d()));
	}

	/**
	  * get a resized copy of [this] Canvas
	  */
	public function resized(w:Float, h:Float):Canvas {
		var copy = Canvas.create(floor(w), floor(h));
		copy.context.drawImage(canvas, 0, 0, width, height, 0, 0, copy.width, copy.height);
		return copy;
	}

	/**
	  * Scale [this] Canvas
	  */
	public function scale(w:Float, ?h:Float):Canvas {
		if (h == null)
			h = w;
		var copy:Canvas = create(floor(w * width), floor(h * height));
		copy.context.drawImage(canvas, 0, 0, width, height, 0, 0, copy.width, copy.height);
		return copy;
	}

	/**
	  * Paint [this] Canvas onto another
	  */
	public function paint(c:Ctx, src:Rectangle, dest:Rectangle):Void {
		c.drawImage(canvas, src.x, src.y, src.w, src.h, dest.x, dest.y, dest.w, dest.h);
	}
	public function getWidth():Int return width;
	public function getHeight():Int return height;

	/**
	  * Get the DataURI for [this] Canvas
	  */
	public inline function dataURI(?type:String):String {
		return canvas.toDataURL( type );
	}

	/**
	  * Get a Blob from [this] Canvas
	  */
	public inline function toBlob(cb:JBlob->Void, ?type:String):Void {
		canvas.toBlob(cb, type);
	}

	/**
	  * Get an Image from [this] Canvas
	  */
	public inline function getImage(cb:Image->Void, ?type:String):Void {
		Image.load(dataURI( type ), cb);
	}
	/*
	public function getImage(callback:Image->Void, ?type:String):Void {
		toBlob(function(blob : JBlob) {
			var blobUrl:String = (untyped __js__('(window.URL || window.webkitURL).createObjectURL.bind( window )'))( blob );
			Image.load(blobUrl, callback);
		}, type);
	}
	*/

/* === Computed Instance Methods === */

	/* the width of [this] Canvas */
	public var width(get, set):Int;
	private inline function get_width() return canvas.width;
	private inline function set_width(v : Int):Int {
		resize(v, height);
		return width;
	}

	/* the height of [this] Canvas */
	public var height(get, set):Int;
	private inline function get_height() return canvas.height;
	private inline function set_height(v : Int):Int {
		resize(width, v);
		return height;
	}

	/* the current drawing context */
	public var context(get, never):Ctx;
	private inline function get_context():Ctx {
		return _ctx.get();
	}

	/* the pixels of [this] Canvas */
	public var pixels(get, never):Pixels;
	private function get_pixels():Pixels {
		return context.getPixels(0, 0, width, height).link(context, new Rectangle(0, 0, width, height));
	}

/* === Instance Methods === */

	private var canvas : NCanvas;
	private var _ctx : Ref<Ctx>;

/* === Static Methods === */

	/**
	  * Create and return a new Canvas of the given size
	  */
	public static function create(w:Int, h:Int):Canvas {
		var can:Canvas = new Canvas();
		can.resize(w, h);
		return can;
	}

	public static function fromPixels(pixels : Pixels):Canvas {
	    var c = create(pixels.width, pixels.height);
	    c.context.putPixels(pixels, 0, 0);
	    return c;
	}
}
