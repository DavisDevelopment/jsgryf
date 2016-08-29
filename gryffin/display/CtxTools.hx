package gryffin.display;

import tannus.geom.*;
import tannus.ds.ActionStack.ParametricStack in PStack;
import tannus.ds.Object;
import tannus.io.Ptr;

import gryffin.display.*;
#if !macro
import js.html.CanvasRenderingContext2D in Context;
import js.Lib.nativeThis in nthis;
#end

using Lambda;
using tannus.ds.ArrayTools;

class CtxTools {
#if !macro
	/**
	  * Patched CanvasRenderingContext2D::measureText
	  */
	public static function patchedMeasureText(c:Context, txt:String):gryffin.display.Context.TextMetrics {
		var font = c.font;
		var w = c.measureText( txt ).width;
		var th = getTextHeight( font );
		
		return {
			'width': w,
			'height': th.height,
			'ascent': th.ascent,
			'descent': th.descent
		};
	}

	/**
	  * Measure the height of drawn text with the given Font
	  */
	private static function getTextHeight(font : String):{ascent:Float, descent:Float, height:Float} {
		var doc = js.Browser.document;
		
		var span = doc.createSpanElement();
		span.style.font = font;
		span.textContent = 'Hg';

		var block = doc.createDivElement();
		block.style.display = 'inline-block';
		block.style.width = '1px';
		block.style.height = '0px';

		var div = doc.createDivElement();
		div.appendChild( span );
		div.appendChild( block );

		var body = doc.body;
		body.appendChild( div );

		// the object that this function will return
		var result = {
			'ascent'  : 0.0,
			'descent' : 0.0,
			'height'  : 0.0
		};

		try {
			var bo = offset.bind( block );
			var so = offset.bind( span );
			var align = Ptr.create( block.style.verticalAlign );
			
			align &= 'baseline';
			result.ascent = (bo().top - so().top);

			align &= 'bottom';
			result.height = (bo().top - so().top);
			result.descent = (result.height - result.ascent);

			div.remove();
			return result;
		}
		catch(err : Dynamic) {
			trace( err );
			div.remove();
		}

		return result;
	}

	/**
	  * Get the offset of an Element
	  */
	private static function offset(e : js.html.Element):{top:Float, left:Float} {
		try {
			var rect = e.getBoundingClientRect();
			var win = js.Browser.window;
			var doc = win.document.documentElement;

			return {
				'top' : (rect.top + win.pageYOffset - doc.clientTop),
				'left': (rect.left + win.pageXOffset - doc.clientLeft)
			};
		}
		catch(error : Dynamic) {
			trace( error );
			return {
				'top': 0,
				'left': 0
			};
		}
	}

	/**
	  * Draw a Vertex-List
	  */
	public static function drawVertices(c:Ctx, vertices:Vertices):Void {
		var points:Array<Point> = vertices;
		var first:Point = points.shift();
		c.moveTo(first.x, first.y);
		for (p in points) {
			c.lineTo(p.x, p.y);
		}
		c.lineTo(first.x, first.y);
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
#end
}
