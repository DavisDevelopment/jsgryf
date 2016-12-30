package gryffin.display;

import gryffin.display.*;
import gryffin.Tools.defer;

import tannus.geom.*;
import tannus.ds.Ref;
import tannus.io.Getter;
import tannus.io.VoidSignal;

import Math.*;
import tannus.math.TMath;

import js.html.Image in Img;
import js.Browser.document in doc;

using tannus.math.TMath;
using tannus.ds.ArrayTools;

class Image implements BitmapSource {
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
		img.addEventListener('load', function(event:Dynamic) {
			ready.fire();
		});
		img.addEventListener('error', function(error:Dynamic) {
			trace( error );
		});
		
		if ( img.complete ) {
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
		}
		else {
			c.save();
			c.fillStyle = '#000000';
			c.fillRect(0, 0, targetWidth, targetHeight);
			c.restore();

			ready.once(function() {
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
		//if ( complete ) {
		c.drawImage(img, s.x, s.y, s.w, s.h, d.x, d.y, d.w, d.h);
		/*
		}
		else {
			c.beginPath();
			c.fillStyle = '#000';
			c.rect(d.x, d.y, d.w, d.h);
			c.closePath();
			c.fill();
		}
		*/
	}

	/**
	  * Rotate [this] Image
	  */
	public function rotate(angle : Angle):Canvas {
		var r = new Rectangle(0, 0, width, height);
		var rr = rotatedSize( angle );
		var can = Canvas.create(floor(rr.w), floor(rr.h));
		var cr = new Rectangle(0, 0, can.width, can.height);
		var c = can.context;
		c.save();
		c.translate(cr.centerX, cr.centerY);
		c.rotate( angle.radians );
		c.translate(-cr.centerX, -cr.centerY);
		c.drawImage(img, 0, 0, width, height, 0, 0, cr.w, cr.h);
		c.restore();
		return can;
	}

	/**
	  * Get the size of [this] Image, if rotated by the given Angle
	  */
	public function rotatedSize(angle : Angle):Rectangle {
		var r = angle.radians;
		var a = (width * cos( r ));
		var b = (height * sin( r ));
		var rotatedWidth = (a + b);
		var p = (width * sin(r));
		var q = (height * cos(r));
		var rotatedHeight = (p + q);
		return new Rectangle(0, 0, rotatedWidth, rotatedHeight);
	}

	public function getWidth():Int return width;
	public function getHeight():Int return height;

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
	private inline function get_complete():Bool return (img.complete && (src != null) && (src != ''));

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
		if (!registry.exists( src )) {
			var img:Image = new Image();
			if (cb != null) {
				img.ready.once(function() {
					defer(cb.bind( img ));
				});
			}
			img.src = src;
			registry[src] = img;
			return img;
		}
		else {
			var img:Image = registry.get( src );
			if (cb != null) {
				(img.complete ? defer : img.ready.once)(cb.bind( img ));
			}
			return img;
		}
	}

	/* registry of all Images which have been loaded so far */
	private static var registry:Map<String, Image> = {new Map();};
}
