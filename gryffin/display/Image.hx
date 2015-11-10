package gryffin.display;

import gryffin.display.*;
import gryffin.Tools.defer;

import tannus.geom.*;
import tannus.ds.Ref;
import tannus.io.Getter;
import tannus.io.VoidSignal;

import js.html.Image in Img;
import js.Browser.document in doc;

class Image implements Paintable {
	/* Constructor Function */
	public function new(?i : Img):Void {
		img = (i != null ? i : cast doc.createImageElement());
		ready = new VoidSignal();
		targetWidth = targetHeight = 0;

		__init();
	}

/* === Instance Methods === */

	/**
	  * Initialize [this] Image
	  */
	private inline function __init():Void {
		img.onload = defer.bind(ready.fire);
		img.onerror = function(err : Dynamic) {
			js.Browser.console.error( err );
		};
		
		if (img.complete) {
			defer( ready.fire );
		}
	}

	/**
	  * Convert [this] Image to a Canvas
	  */
	public function toCanvas():Canvas {
		var can:Canvas = Canvas.create(targetWidth, targetHeight);
		var c = can.context;

		if (complete) {
			can.resize(width, height);
			c = can.context;
			c.drawComponent(this, 0, 0, width, height, 0, 0, width, height);
			trace('Image already loaded');
		}
		else {
			trace('Image not loaded');
			c.save();
			c.fillStyle = '#000000';
			c.fillRect(0, 0, targetWidth, targetHeight);
			c.restore();

			ready.once(function() {
				trace('Image now loaded');
				trace([width, height]);
				can.resize(width, height);
				c = can.context;
				c.drawComponent(this, 0, 0, width, height, 0, 0, width, height);
			});
		}

		return can;
	}

	/**
	  * Paint [this] Image to a Canvas
	  */
	public function paint(c:Ctx, s:Rectangle, d:Rectangle):Void {
		c.drawImage(img, s.x, s.y, s.w, s.h, d.x, d.y, d.w, d.h);
	}

/* === Computed Instance Fields === */

	/* the 'src' of [this] Image */
	public var src(get, set):String;
	private inline function get_src():String {
		return (img.src);
	}
	private inline function set_src(v : String):String {
		return (img.src = v);
	}

	/* the width of [this] Image */
	public var width(get, never):Int;
	private inline function get_width() return img.naturalWidth;

	/* the height of [this] Image */
	public var height(get, never):Int;
	private inline function get_height() return img.naturalHeight;

	/* the rectangle of [this] Image */
	public var rect(get, never):Rectangle;
	private inline function get_rect():Rectangle {
		return new Rectangle(0, 0, width, height);
	}

	/* whether [this] Image is loaded */
	public var complete(get, never):Bool;
	private inline function get_complete():Bool return img.complete;

/* === Instance Fields === */

	private var img : Img;
	private var targetWidth : Int;
	private var targetHeight : Int;

	public var ready : VoidSignal;

/* === Static Methods === */

	/**
	  * Create a new Image with the given source
	  */
	public static function load(src:String, ?cb:Image->Void):Image {
		var img:Image = new Image();
		img.src = src;
		if (cb != null)
			img.ready.once(cb.bind(img));
		return img;
	}
}
