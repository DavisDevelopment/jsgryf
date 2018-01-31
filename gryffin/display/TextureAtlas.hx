package gryffin.display;

import gryffin.display.*;

import tannus.geom2.Rect;

class TextureAtlas {
	/* Constructor Function */
	public function new(img : Image):Void {
		sheet = img;
		sprites = new Map();
	}

/* === Instance Methods === */

	/**
	  * register a Texture in [this] atlas
	  */
	public inline function set(name:String, x:Int, y:Int, w:Int, h:Int):Void {
		sprites[name] = {
			'x' : x,
			'y' : y,
			'width' : w,
			'height': h
		};
	}

	/**
	  * get a Texture from [this] atlas
	  */
	public inline function get(name : String):Null<Texture> {
		return new Texture(this, name);
	}

	/**
	  * delete a registry
	  */
	public inline function remove(name : String):Bool {
		return sprites.remove(name);
	}

/* === Instance Fields === */

	private var sheet : Image;
	private var sprites : Map<String, TextureBounds>;
}

typedef TextureBounds = {
	var x : Int;
	var y : Int;
	var width : Int;
	var height : Int;
};
