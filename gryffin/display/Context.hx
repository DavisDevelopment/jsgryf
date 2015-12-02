package gryffin.display;

import js.html.*;

import tannus.geom.*;
import tannus.ds.Stack;

using gryffin.display.CtxTools;

class Context {
	/* Constructor Function */
	public function new(ctx : CanvasRenderingContext2D):Void {
		this.ctx = ctx;
		states = new Stack();
		matrix = new Matrix();
	}

/* === Instance Methods === */

	/**
	  * Clear the entire Canvas area
	  */
	public function erase():Void {
		ctx.clearRect(0, 0, width, height);
	}

	/**
	  * Paint some object onto [this] Context
	  */
	public function paint(comp:Paintable, src:Rectangle, dest:Rectangle):Void {
		comp.paint(ctx, src, dest);
	}

	/**
	  * Draw a Paintable object
	  */
	public function drawComponent(comp:Paintable, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Float, dh:Float):Void {
		var src:Rectangle = new Rectangle(sx, sy, sw, sh);
		var dest:Rectangle = new Rectangle(dx, dy, dw, dh);
		comp.paint(ctx, src, dest);
	}

	/**
	  * Draw a vertex array
	  */
	public function drawVertices(vertices:Vertices, ?closed:Bool):Void {
		ctx.drawVertices(vertices, closed);
	}

	/**
	  * Apply a Matrix to [this]
	  */
	public function applyMatrix(m : Matrix):Void {
		/* if the only non-null transforms are 'tx' and 'ty' */
		if (m.a == 1 && m.b == 0 && m.c == 0 && m.d == 1) {
			ctx.translate(m.tx, m.ty);
		}
		/* otherwise */
		else {
			ctx.setTransform(m.a, m.b, m.c, m.d, m.tx, m.ty);
		}
	}

	/**
	  * Get the current Matrix of [this]
	  */
	public function obtainMatrix():Matrix {
		return matrix.clone();
	}

	public function save():Void {
		ctx.save();
		states.add(State.create( this ));
	}


	public function restore():Void {
		ctx.restore();
		
		if ( !states.empty ) {
			states.pop().apply( this );
		}
	}


	public function scale(x:Float, y:Float):Void {
		ctx.scale(x, y);
		matrix.scale(x, y);
	}


	public function rotate(angle:Float):Void {
		ctx.rotate( angle );
		matrix.rotate( angle );
	}


	public function translate(x:Float, y:Float):Void {
		ctx.translate(x, y);
		matrix.translate(x, y);
	}


	public function transform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void {
		ctx.transform(a, b, c, d, e, f);
	}


	public function setTransform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void {
		ctx.setTransform(a, b, c, d, e, f);
		matrix.a = a;
		matrix.b = b;
		matrix.c = c;
		matrix.d = d;
		matrix.tx = e;
		matrix.ty = f;
	}


	public function resetTransform():Void {
		ctx.resetTransform();
		matrix.identity();
	}


	public function createLinearGradient(x0:Float, y0:Float, x1:Float, y1:Float):CanvasGradient {
		return ctx.createLinearGradient(x0, y0, x1, y1);
	}


	public function createRadialGradient(x0:Float, y0:Float, r0:Float, x1:Float, y1:Float, r1:Float):CanvasGradient {
		return ctx.createRadialGradient(x0, y0, r0, x1, y1, r1);
	}


	public function clearRect(x:Float, y:Float, w:Float, h:Float):Void {
		ctx.clearRect(x, y, w, h);
	}


	public function fillRect(x:Float, y:Float, w:Float, h:Float):Void {
		ctx.fillRect(x, y, w, h);
	}


	public function strokeRect(x:Float, y:Float, w:Float, h:Float):Void {
		ctx.strokeRect(x, y, w, h);
	}


	public function beginPath():Void {
		ctx.beginPath();
	}


	public function fill():Void {
		ctx.fill();
	}


	public function stroke():Void {
		ctx.stroke();
	}


	public function drawFocusIfNeeded(element:Element):Void {
		ctx.drawFocusIfNeeded(element);
	}


	public function drawCustomFocusRing(element:Element):Bool {
		return ctx.drawCustomFocusRing(element);
	}


	public function clip():Void {
		ctx.clip();
	}


	public function isPointInPath(path:Path2D, x:Float, y:Float, winding:CanvasWindingRule):Bool {
		return ctx.isPointInPath(path, x, y, winding);
	}


	public function isPointInStroke(path:Path2D, x:Float, y:Float):Bool {
		return ctx.isPointInStroke(path, x, y);
	}

	/**
	  * Draw the given text
	  */
	public function fillText(text:String, x:Float, y:Float, ?maxWidth:Float):Void {
		if (maxWidth != null)
			ctx.fillText(text, x, y, maxWidth);
		else
			ctx.fillText(text, x, y);
	}


	/**
	  * Draw the outline of the given text
	  */
	public function strokeText(text:String, x:Float, y:Float, ?maxWidth:Float):Void {
		if (maxWidth != null)
			ctx.strokeText(text, x, y, maxWidth);
		else
			ctx.strokeText(text, x, y);
	}


	/**
	  * Measure some text when drawn with the current settings
	  */
	public function measureText(text:String):TextMetrics {
		return ctx.patchedMeasureText( text );
	}


	public function drawImage(image:Dynamic, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Float, dh:Float):Void {
		ctx.drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh);
	}


	public function addHitRegion(options:HitRegionOptions):Void {
		ctx.addHitRegion(options);
	}


	public function removeHitRegion(id:String):Void {
		ctx.removeHitRegion(id);
	}


	public function clearHitRegions():Void {
		ctx.clearHitRegions();
	}


	public function createImageData(imagedata:ImageData):ImageData {
		return ctx.createImageData(imagedata);
	}


	public function getImageData(sx:Float, sy:Float, sw:Float, sh:Float):ImageData {
		return ctx.getImageData(sx, sy, sw, sh);
	}


	public function putImageData(imagedata:ImageData, dx:Float, dy:Float, dirtyX:Float, dirtyY:Float, dirtyWidth:Float, dirtyHeight:Float):Void {
		ctx.putImageData(imagedata, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
	}


	public function setLineDash(segments:Array<Float>):Void {
		ctx.setLineDash(segments);
	}


	public function getLineDash():Array<Float> {
		return ctx.getLineDash();
	}


	public function closePath():Void {
		ctx.closePath();
	}


	public function moveTo(x:Float, y:Float):Void {
		ctx.moveTo(x, y);
	}


	public function lineTo(x:Float, y:Float):Void {
		ctx.lineTo(x, y);
	}


	public function quadraticCurveTo(cpx:Float, cpy:Float, x:Float, y:Float):Void {
		ctx.quadraticCurveTo(cpx, cpy, x, y);
	}


	public function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float):Void {
		ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
	}


	public function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void {
		ctx.arcTo(x1, y1, x2, y2, radius);
	}


	public function rect(x:Float, y:Float, w:Float, h:Float):Void {
		ctx.rect(x, y, w, h);
	}

	/**
	  * add a rounded rect to the path
	  */
	public function roundRect(x:Float, y:Float, w:Float, h:Float, r:Float):Void {
		ctx.moveTo(x + r, y);
		ctx.lineTo(x + w - r, y);
		ctx.quadraticCurveTo(x + w, y, x + w, y + r);
		ctx.lineTo(x + w, y + h - r);
		ctx.quadraticCurveTo(x + w, y + h, x + w - r, y + h);
		ctx.lineTo(x + r, y + h);
		ctx.quadraticCurveTo(x, y + h, x, y + h - r);
		ctx.lineTo(x, y + r);
		ctx.quadraticCurveTo(x, y, x + r, y);
	}

	public function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool):Void {
		ctx.arc(x, y, radius, startAngle, endAngle, anticlockwise);
	}

	/* === Instance Fields === */

	public var canvas(get, never):CanvasElement;
	private function get_canvas():CanvasElement return ctx.canvas;


	public var globalAlpha(get, set):Float;
	private function get_globalAlpha():Float return ctx.globalAlpha;
	private function set_globalAlpha(v : Float):Float return (ctx.globalAlpha = v);


	public var globalCompositeOperation(get, set):String;
	private function get_globalCompositeOperation():String return ctx.globalCompositeOperation;
	private function set_globalCompositeOperation(v : String):String return (ctx.globalCompositeOperation = v);


	public var strokeStyle(get, set):Dynamic;
	private function get_strokeStyle():Dynamic return ctx.strokeStyle;
	private function set_strokeStyle(v : Dynamic):Dynamic return (ctx.strokeStyle = v);


	public var fillStyle(get, set):Dynamic;
	private function get_fillStyle():Dynamic return ctx.fillStyle;
	private function set_fillStyle(v : Dynamic):Dynamic return (ctx.fillStyle = v);


	public var shadowOffsetX(get, set):Float;
	private function get_shadowOffsetX():Float return ctx.shadowOffsetX;
	private function set_shadowOffsetX(v : Float):Float return (ctx.shadowOffsetX = v);


	public var shadowOffsetY(get, set):Float;
	private function get_shadowOffsetY():Float return ctx.shadowOffsetY;
	private function set_shadowOffsetY(v : Float):Float return (ctx.shadowOffsetY = v);


	public var shadowBlur(get, set):Float;
	private function get_shadowBlur():Float return ctx.shadowBlur;
	private function set_shadowBlur(v : Float):Float return (ctx.shadowBlur = v);


	public var shadowColor(get, set):String;
	private function get_shadowColor():String return ctx.shadowColor;
	private function set_shadowColor(v : String):String return (ctx.shadowColor = v);


	public var filter(get, set):String;
	private function get_filter():String return ctx.filter;
	private function set_filter(v : String):String return (ctx.filter = v);


	public var imageSmoothingEnabled(get, set):Bool;
	private function get_imageSmoothingEnabled():Bool return ctx.imageSmoothingEnabled;
	private function set_imageSmoothingEnabled(v : Bool):Bool return (ctx.imageSmoothingEnabled = v);


	public var lineWidth(get, set):Float;
	private function get_lineWidth():Float return ctx.lineWidth;
	private function set_lineWidth(v : Float):Float return (ctx.lineWidth = v);


	public var lineCap(get, set):String;
	private function get_lineCap():String return ctx.lineCap;
	private function set_lineCap(v : String):String return (ctx.lineCap = v);


	public var lineJoin(get, set):String;
	private function get_lineJoin():String return ctx.lineJoin;
	private function set_lineJoin(v : String):String return (ctx.lineJoin = v);


	public var miterLimit(get, set):Float;
	private function get_miterLimit():Float return ctx.miterLimit;
	private function set_miterLimit(v : Float):Float return (ctx.miterLimit = v);


	public var lineDashOffset(get, set):Float;
	private function get_lineDashOffset():Float return ctx.lineDashOffset;
	private function set_lineDashOffset(v : Float):Float return (ctx.lineDashOffset = v);


	public var font(get, set):String;
	private function get_font():String return ctx.font;
	private function set_font(v : String):String return (ctx.font = v);


	public var textAlign(get, set):String;
	private function get_textAlign():String return ctx.textAlign;
	private function set_textAlign(v : String):String return (ctx.textAlign = v);


	public var textBaseline(get, set):String;
	private function get_textBaseline():String return ctx.textBaseline;
	private function set_textBaseline(v : String):String return (ctx.textBaseline = v);

	public var width(get, never):Int;
	private function get_width() return this.canvas.width;

	public var height(get, never):Int;
	private function get_height() return this.canvas.height;

	/* the underlying CanvasRenderingContext2D object */
	private var ctx : CanvasRenderingContext2D;

	/* the current Matrix in use by [this] Context */
	private var matrix : Matrix;

	/* the current StateStack in use by [this] Context */
	private var states : Stack<State>;
}

typedef TextMetrics = {
	var width : Float;
	var height : Float;
	var ascent : Float;
	var descent : Float;
};

private class State {
	/* Constructor Function */
	public function new():Void {
		matrix = new Matrix();
	}

/* === Instance Methods === */

	/**
	  * Apply [this] State to a Context
	  */
	public function apply(c : Context):Void {
		c.applyMatrix( matrix );
	}

/* === Instance Fields === */

	public var matrix : Matrix;

/* === Class Methods === */

	/**
	  * Create a State from a Context
	  */
	public static function create(c : Context):State {
		var s = new State();
		s.matrix = c.obtainMatrix();
		return s;
	}
}
