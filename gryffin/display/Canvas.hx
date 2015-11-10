package gryffin.display;

import tannus.ds.Ref;
import tannus.geom.*;

import gryffin.display.Ctx;
import gryffin.display.Paintable;

import js.html.CanvasElement in NCanvas;
import js.Browser.document in doc;

class Canvas implements Paintable {
	/* Constructor Function */
	public function new(?c:NCanvas):Void {
		if (c != null)
			canvas = c;
		else
			canvas = doc.createCanvasElement();
		_ctx = new Ref(cast canvas.getContext.bind('2d'));
	}

/* === Instance Methods === */

	/**
	  * Resize [this] Canvas
	  */
	public function resize(w:Int, h:Int):Void {
		canvas.width = w;
		canvas.height = h;
		_ctx = new Ref(cast canvas.getContext.bind('2d'));
	}

	/**
	  * Paint [this] Canvas onto another
	  */
	public function paint(c:Ctx, src:Rectangle, dest:Rectangle):Void {
		c.drawImage(canvas, src.x, src.y, src.w, src.h, dest.x, dest.y, dest.w, dest.h);
	}

	/**
	  * Get the DataURI for [this] Canvas
	  */
	public function dataURI(?type:String):String {
		return canvas.toDataURL( type );
	}

	/**
	  * Get an Image from [this] Canvas
	  */
	public function getImage(cb : Image->Void):Void {
		Image.load(dataURI(), cb);
	}

	/**
	  * Get a Pixels object
	  */
	public function pixels(x:Float, y:Float, w:Float, h:Float):Pixels {
		var idata = context.getImageData(x, y, w, h);
		var pos = new Point(x, y);
		return new Pixels(this, pos, idata);
	}

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
}
