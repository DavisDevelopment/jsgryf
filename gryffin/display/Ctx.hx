package gryffin.display;

import tannus.geom.*;

import gryffin.display.Paintable;

import js.html.CanvasRenderingContext2D in Context;

using gryffin.display.CtxTools;

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

	/**
	  * Paint some object onto [this] Context
	  */
	public inline function paint(comp:Paintable, src:Rectangle, dest:Rectangle):Void {
		comp.paint(this, src, dest);
	}

	/**
	  * Draw a Paintable object
	  */
	public inline function drawComponent(comp:Paintable, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Float, dh:Float):Void {
		paint(comp, new Rectangle(sx, sy, sw, sh), new Rectangle(dx, dy, dw, dh));
	}

	/**
	  * CanvasRenderingContext2D::measureText patched to also measure height
	  */
	public inline function measureText(txt : String):TextMetrics {
		return this.patchedMeasureText( txt );
	}

	/**
	  * Apply the given Matrix
	  */
	public inline function setMatrix(m : Matrix):Void {
		this.applyMatrix( m );
	}

	/**
	  * Get the current Matrix
	  */
	public inline function getMatrix():Matrix {
		return this.obtainMatrix();
	}

/* === Instance Fields === */

	public var width(get, never):Int;
	private inline function get_width() return this.canvas.width;

	public var height(get, never):Int;
	private inline function get_height() return this.canvas.height;
}

typedef TextMetrics = {
	width : Float,
	height : Float
};
