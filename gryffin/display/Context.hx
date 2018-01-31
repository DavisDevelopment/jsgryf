package gryffin.display;

#if !macro
import js.html.*;
#end

import tannus.geom2.*;
import tannus.ds.Stack;
import gryffin.display.Pixels;

using gryffin.display.CtxTools;

class Context {
	/* Constructor Function */
	public function new(ctx : CanvasRenderingContext2D):Void {
		this.ctx = ctx;
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
	public inline function paint(comp:Paintable, src:Rect<Float>, dest:Rect<Float>):Void {
		comp.paint(ctx, src, dest);
	}

	/**
	  * Draw a Paintable object
	  */
	public function drawComponent(comp:Paintable, sx:Float, sy:Float, sw:Float, sh:Float, dx:Float, dy:Float, dw:Float, dh:Float):Void {
	    inline function rect(x,y,w,h):Rect<Float> return new Rect(x, y, w, h);
        var src:Rect<Float> = new Rect(sx, sy, sw, sh);
		var dest:Rect<Float> = new Rect(dx, dy, dw, dh);
        comp.paint(this, src, dest);
		//comp.paint(this, rect(sx, sy, sw, sh), rect(dx, dy, dw, dh));
	}

	/**
	  * Draw a vertex array
	  */
	public inline function drawVertices(vertices : VertexArray<Float>):Void {
		ctx.drawVertices( vertices );
	}

	public inline function save():Void {
		ctx.save();
	}


	public inline function restore():Void {
		ctx.restore();
	}


	public inline function scale(x:Float, y:Float):Void {
		ctx.scale(x, y);
	}


	public inline function rotate(angle:Float):Void {
		ctx.rotate( angle );
	}


	public inline function translate(x:Float, y:Float):Void {
		ctx.translate(x, y);
	}


	public inline function transform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void {
		ctx.transform(a, b, c, d, e, f);
	}


	public inline function setTransform(a:Float, b:Float, c:Float, d:Float, e:Float, f:Float):Void {
		ctx.setTransform(a, b, c, d, e, f);
	}


	public inline function resetTransform():Void {
		ctx.resetTransform();
	}


	public inline function createLinearGradient(x0:Float, y0:Float, x1:Float, y1:Float):CanvasGradient {
		return ctx.createLinearGradient(x0, y0, x1, y1);
	}


	public inline function createRadialGradient(x0:Float, y0:Float, r0:Float, x1:Float, y1:Float, r1:Float):CanvasGradient {
		return ctx.createRadialGradient(x0, y0, r0, x1, y1, r1);
	}

    /*
       create and return a new CanvasPattern
    */
	public function createPattern(imgSource:Dynamic, repetition:String):CanvasPattern {
	    var img:Dynamic = imgSource;
	    if (Std.is(imgSource, gryffin.display.Canvas)) {
	        img = @:privateAccess cast(imgSource, Canvas).canvas;
	    }
        else if (Std.is(imgSource, gryffin.display.Image)) {
            img = @:privateAccess cast(imgSource, gryffin.display.Image).img;
        }
        else if (Std.is(imgSource, gryffin.display.Video)) {
            img = @:privateAccess cast(imgSource, Video).vid;
        }
        return ctx.createPattern(img, repetition);
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


	public inline function beginPath():Void {
		ctx.beginPath();
	}


	public inline function fill():Void {
		ctx.fill();
	}


	public inline function stroke():Void {
		ctx.stroke();
	}


	public inline function drawFocusIfNeeded(element:Element):Void {
		ctx.drawFocusIfNeeded(element);
	}


	public inline function drawCustomFocusRing(element:Element):Bool {
		return ctx.drawCustomFocusRing(element);
	}


	public inline function clip():Void {
		ctx.clip();
	}


	public inline function isPointInPath(path:Path2D, x:Float, y:Float, winding:CanvasWindingRule):Bool {
		return ctx.isPointInPath(path, x, y, winding);
	}


	public inline function isPointInStroke(path:Path2D, x:Float, y:Float):Bool {
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
	public inline function measureText(text:String):TextMetrics {
		return ctx.patchedMeasureText( text );
	}


	public function drawImage(image:Dynamic, sx:Float, sy:Float, ?sw:Float, ?sh:Float, ?dx:Float, ?dy:Float, ?dw:Float, ?dh:Float):Void {
		ctx.drawImage(image, sx, sy, sw, sh, dx, dy, dw, dh);
	}


	public inline function addHitRegion(options:HitRegionOptions):Void {
		ctx.addHitRegion(options);
	}


	public inline function removeHitRegion(id:String):Void {
		ctx.removeHitRegion(id);
	}


	public inline function clearHitRegions():Void {
		ctx.clearHitRegions();
	}


	public inline function createImageData(w:Int, h:Int):ImageData {
		return ctx.createImageData(w, h);
	}


	public function getImageData(sx:Float, sy:Float, sw:Float, sh:Float):ImageData {
		return ctx.getImageData(sx, sy, sw, sh);
	}

	/**
	  * Get the Pixels in the given area
	  */
	public inline function getPixels(x:Float, y:Float, w:Float, h:Float):Pixels {
		return new Pixels(getImageData(x, y, w, h));
	}

	public inline function putPixels(pixels:Pixels, x:Float, y:Float, ?dx:Float, ?dy:Float, ?dw:Float, ?dh:Float):Void {
		putImageData(pixels.imageData, x, y, dx, dy, dw, dh);
	}

	public inline function putImageData(imagedata:ImageData, dx:Float, dy:Float, ?dirtyX:Float, ?dirtyY:Float, ?dirtyWidth:Float, ?dirtyHeight:Float):Void {
		ctx.putImageData(imagedata, dx, dy, dirtyX, dirtyY, dirtyWidth, dirtyHeight);
	}


	public inline function setLineDash(segments:Array<Float>):Void {
		ctx.setLineDash(segments);
	}


	public inline function getLineDash():Array<Float> {
		return ctx.getLineDash();
	}


	public inline function closePath():Void {
		ctx.closePath();
	}


	public inline function moveTo(x:Float, y:Float):Void {
		ctx.moveTo(x, y);
	}

	/* move to the given Point */
	public inline function moveToPoint(p : Point<Float>):Void {
		moveTo(p.x, p.y);
	}


	public inline function lineTo(x:Float, y:Float):Void {
		ctx.lineTo(x, y);
	}

	/* draw a line to the given Point */
	public inline function lineToPoint(p : Point<Float>):Void {
		lineTo(p.x, p.y);
	}

	public inline function lineToPoints(ip: Iterable<Point<Float>>):Void {
	    for (p in ip)
	        lineToPoint( p );
	}


	public inline function quadraticCurveTo(cpx:Float, cpy:Float, x:Float, y:Float):Void {
		ctx.quadraticCurveTo(cpx, cpy, x, y);
	}


	public inline function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float):Void {
		ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, x, y);
	}


	public inline function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void {
		ctx.arcTo(x1, y1, x2, y2, radius);
	}

	/**
	  * draw a rect
	  */
	public inline function rect(x:Float, y:Float, w:Float, h:Float):Void {
		ctx.rect(x, y, w, h);
	}

	/**
	  * draw a rect from a Rectangle instance
	  */
	public inline function drawRect(r : Rect<Float>):Void {
		rect(r.x, r.y, r.w, r.h);
	}

	/**
	  * draw a triangle
	  */
	public inline function drawTriangle(t:Triangle<Float>, move:Bool=true):Void {
	    if ( move ) {
	        moveToPoint( t.a );
	    }
	    lineToPoint( t.b );
	    lineToPoint( t.c );
	}

	/**
	  * draw a line from a Line instance
	  */
	public inline function drawLine(line:Line<Float>):Void {
		moveToPoint( line.a );
		lineToPoint( line.b );
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

	/**
	  * draw a rounded Rectangle
	  */
	public inline function drawRoundRect(rect:Rect<Float>, radius:Float):Void {
		roundRect(rect.x, rect.y, rect.w, rect.h, radius);
	}

	public inline function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool):Void {
		ctx.arc(x, y, radius, startAngle, endAngle, anticlockwise);
	}

	public inline function drawArc(a:Arc<Float>):Void {
	    arc(a.x, a.y, a.radius, a.start_angle.getRadians(), a.end_angle.getRadians(), !a.clockwise);
	}

	public inline function drawBezier(b:Bezier<Float>, move:Bool=true):Void {
	    if ( move ) {
	        moveToPoint( b.start );
	    }

	    bezierCurveTo(b.ctrl1.x, b.ctrl1.y, b.ctrl2.x, b.ctrl2.y, b.end.x, b.end.y);
	}

	public inline function drawEllipse(e:Ellipse<Float>):Void {
	    var b = e.calculateCurves();
	    drawBezier(b[0], true);
	    drawBezier(b[1], false);
	    drawBezier(b[2], false);
	    drawBezier(b[3], false);
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

	/* the width of [this] Context */
	public var width(get, never):Int;
	private function get_width() return this.canvas.width;

	/* the height of [this] Context */
	public var height(get, never):Int;
	private function get_height() return this.canvas.height;

	/* the underlying CanvasRenderingContext2D object */
	private var ctx : CanvasRenderingContext2D;
}

typedef TextMetrics = {
	var width : Float;
	var height : Float;
	var ascent : Float;
	var descent : Float;
};

#if macro

private typedef CanvasRenderingContext2D = Dynamic;
private typedef CanvasElement = Dynamic;
private typedef Element = Dynamic;
private typedef CanvasWindingRule = Dynamic;
private typedef HitRegionOptions = Dynamic;
private typedef ImageData = Dynamic;
private typedef CanvasGradient = Dynamic;
private typedef Path2D = Dynamic;

#end
