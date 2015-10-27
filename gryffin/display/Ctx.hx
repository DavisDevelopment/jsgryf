package gryffin.display;

import js.html.CanvasRenderingContext2D in Context;

@:forward
abstract Ctx (Context) from Context to Context {
	/* Constructor Function */
	public inline function new(c : Context):Void {
		this = c;
	}

/* === Instance Methods === */

	/**
	  * Clear the entire Canvas area
	  */
	public inline function erase():Void {
		this.clearRect(0, 0, width, height);
	}

/* === Instance Fields === */

	public var width(get, never):Int;
	private inline function get_width() return this.canvas.width;

	public var height(get, never):Int;
	private inline function get_height() return this.canvas.height;
}
