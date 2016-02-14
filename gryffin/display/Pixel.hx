package gryffin.display;

import gryffin.display.*;

import tannus.geom.*;
import tannus.graphics.Color;
import tannus.graphics.Color.Hsl;
import tannus.io.Ptr;

@:access(gryffin.display.Pixels)
class Pixel {
	/* Constructor Function */
	public function new(s:Pixels, p:Point):Void {
		src = s;
		pos = p;
	}

/* === Instance Methods === */

	/**
	  * the hsl data of [this] Pixel
	  */
	public inline function hsl():Hsl return c.toHsl();

	/* the hue of [this] Pixel */
	public inline function hue():Float return hsl().hue;
	public inline function saturation():Float return hsl().saturation;
	public inline function lightness():Float return hsl().lightness;

	public inline function luminance():Float return c.luminance();
	public inline function brightness():Int return c.brightness();
	public function greyscale():Void {
		color = color.greyscale();
	}

/* === Computed Instance Fields === */

	/* the color of [this] Pixel */
	public var color(get, set):Color;
	private inline function get_color():Color {
		return src.getAtPos(pos.x, pos.y);
	}
	private inline function set_color(v : Color):Color {
		return src.setAtPos(pos.x, pos.y, v);
	}

	public var red(get, set):Int;
	private inline function get_red():Int return src.get_red(pos.x, pos.y);
	private inline function set_red(v : Int):Int return src.set_red(pos.x, pos.y, v);

	public var green(get, set):Int;
	private inline function get_green():Int return src.get_green(pos.x, pos.y);
	private inline function set_green(v : Int):Int return src.set_green(pos.x, pos.y, v);

	public var blue(get, set):Int;
	private inline function get_blue():Int return src.get_blue(pos.x, pos.y);
	private inline function set_blue(v : Int):Int return src.set_blue(pos.x, pos.y, v);

	public var alpha(get, set):Int;
	private inline function get_alpha():Int return src.get_alpha(pos.x, pos.y);
	private inline function set_alpha(v : Int):Int return src.set_alpha(pos.x, pos.y, v);

	private var c(get, never):Color;
	private inline function get_c():Color return new Color(red, green, blue, alpha);

/* === Instance Fields === */

	private var src : Pixels;
	private var pos : Point;
}
