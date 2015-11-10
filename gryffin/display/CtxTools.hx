package gryffin.display;

import tannus.geom.*;
import tannus.ds.ActionStack.ParametricStack in PStack;
import tannus.ds.Object;

import gryffin.display.*;
import js.html.CanvasRenderingContext2D in Context;
import js.Lib.nativeThis in nthis;

using Lambda;
using tannus.ds.ArrayTools;

class CtxTools {
	/**
	  * Draw a Vertex-List
	  */
	public static function drawVertices(c:Ctx, vertices:Vertices, closed:Bool=true):Void {
		var points:Array<Point> = vertices;
		var first:Point = points.shift();
		c.beginPath();
		c.moveTo(first.x, first.y);
		for (p in points) {
			c.lineTo(p.x, p.y);
		}
		c.lineTo(first.x, first.y);
		if (closed) {
			c.closePath();
			c.stroke();
		}
		else {
			c.stroke();
			c.closePath();
		}
	}

	/**
	  * Apply the given Matrix to the given Context
	  */
	@:allow(gryffin.display.Ctx)
	private static function applyMatrix(c:Context, m:Matrix):Void {
		/* if the only non-null transforms are 'tx' and 'ty' */
		if (m.a == 1 && m.b == 0 && m.c == 0 && m.d == 1) {
			c.translate(m.tx, m.ty);
		}
		/* otherwise */
		else {
			c.setTransform(m.a, m.b, m.c, m.d, m.tx, m.ty);
		}
	}

	/**
	  * Get the current Matrix on the given Context
	  */
	@:allow(gryffin.display.Ctx)
	private static function obtainMatrix(c : Context):Matrix {
		return new Matrix();
	}

/* === Utility Methods === */

	/**
	  * Initialize [this] Class
	  */
	public static function __init__():Void {

	}
}
