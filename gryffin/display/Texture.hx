package gryffin.display;

import gryffin.display.Ctx;
import gryffin.display.Paintable;
import gryffin.display.Image;
import gryffin.display.TextureAtlas.TextureBounds in Bounds;

import tannus.geom.*;
import tannus.ds.Ref;

using tannus.math.TMath;

@:access(gryffin.display.TextureAtlas)
@:access(gryffin.display.Image)
class Texture implements Paintable {
	/* Constructor Function */
	public function new(owner:TextureAtlas, nam:String):Void {
		atlas = owner;
		name = nam;
		matrix = new Matrix();
	}

/* === Instance Methods === */

	/**
	  * draw [this] texture somewhere
	  */
	public function paint(c:Ctx, src:Rectangle, d:Rectangle):Void {
		c.save();
		c.applyMatrix( matrix );
		var s = atlas.sprites[name];
		c.drawComponent(atlas.sheet, s.x, s.y, s.width, s.height, d.x, d.y, d.w, d.h);
		c.restore();
	}

/* === Instance Fields === */

	private var atlas : TextureAtlas;
	private var name : String;
	public var matrix : Matrix;
}
