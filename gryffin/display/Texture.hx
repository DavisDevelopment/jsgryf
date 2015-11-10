package gryffin.display;

import gryffin.display.Ctx;
import gryffin.display.Paintable;
import gryffin.display.Image;

import tannus.geom.*;
import tannus.ds.Ref;

using tannus.math.TMath;

class Texture implements Paintable {
	/* Constructor Function */
	public function new(img : Image):Void {
		i = img;
	}

/* === Instance Methods === */

	/**
	  * Draw [this] Texture to a Canvas
	  */
	public function paint(c:Ctx, s:Rectangle, d:Rectangle):Void {
		/* draw the Image if it's loaded */
		if ( loaded ) {
			i.paint(c, s, d);
		}

		/* draw a black rectangle if it's not */
		else {
			c.save();
			c.fillStyle = '#000';
			c.beginPath();
			c.fillRect(d.x, d.y, d.w, d.h);
			c.closePath();
			c.restore();
		}
	}

/* === Computed Instance Fields === */

	/* whether the underlying Image is loaded */
	public var loaded(get, never) : Bool;
	private inline function get_loaded():Bool {
		return (i.complete);
	}

	/* the width of [i] */
	public var width(get, never):Int;
	private inline function get_width():Int return (i.width);

	/* the height of [i] */
	public var height(get, never):Int;
	private inline function get_height():Int return (i.height);

	/* the rect of [i] */
	public var rect(get, never):Rectangle;
	private inline function get_rect():Rectangle {
		return (i.rect);
	}

/* === Instance Fields === */

	private var i : Image;

/* === Static Methods === */

	/**
	  * Load a Texture from a given Path
	  */
	public static function load(path:String, ?cb:Texture->Void):Texture {
		var texture = new Texture(Image.load(path, function(img : Image) {
			if (cb != null) {
				cb(untyped texture);
			}
		}));
		return texture;
	}
}
