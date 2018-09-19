package gryffin.display;

#if !macro
//import js.html.*;
import js.html.Path2D as NPath;
#end

import tannus.geom.Matrix;
import tannus.geom2.*;
import tannus.ds.*;
import tannus.io.*;

import haxe.extern.EitherType as Either;

using tannus.math.TMath;
using tannus.ds.ArrayTools;
using StringTools;
using tannus.ds.StringUtils;
using tannus.FunctionTools;
using gryffin.display.CtxTools;



@:forward
abstract Path2D (NPath) from NPath to NPath {
    /* Constructor Function */
    public function new(?config: Path2DInit) {
        if (config != null) {
            this = new NPath(cast config);
        }
        else {
            this = new NPath();
        }
    }

/* === Instance Methods === */

    public function addPath(path:Thunk<Path2DInit>, ?transform:Matrix):Path2D {
        var pi:Path2DInit = path.resolve();
        if ((pi is String)) {
            pi = cast new Path2D(cast pi);
        }
        if (transform == null) {
            this.addPath(cast pi);
        }
        else {
            this.addPath(cast pi, cast transform.toDomMatrix());
        }
        return this;
    }

    public function addRect(rect:Rect<Float>, ?radius:Float):Path2D {
        if (radius == null || radius == 0) {
            this.rect(rect.x, rect.y, rect.width, rect.height);
            return this;
        }
        else {
            return addRoundRect(rect, radius);
        }
    }

    public inline function roundRect(x:Float, y:Float, w:Float, h:Float, r:Float):Path2D {
		this.moveTo(x + r, y);
		this.lineTo(x + w - r, y);
		this.quadraticCurveTo(x + w, y, x + w, y + r);

		this.lineTo(x + w, y + h - r);
		this.quadraticCurveTo(x + w, y + h, x + w - r, y + h);

		this.lineTo(x + r, y + h);
		this.quadraticCurveTo(x, y + h, x, y + h - r);

		this.lineTo(x, y + r);
		this.quadraticCurveTo(x, y, x + r, y);
	    
	    return this;
    }

    public inline function quadraticCurveToPoint(ctrl:Point<Float>, dest:Point<Float>):Path2D {
        this.quadraticCurveTo(ctrl.x, ctrl.y, dest.x, dest.y);
        return this;
    }

    public inline function addRoundRect(rect:Rect<Float>, radius:Float):Path2D {
        return roundRect(rect.x, rect.y, rect.w, rect.h, radius);
    }

    public inline function moveToPoint(p: Point<Float>):Path2D {
        this.moveTo(p.x, p.y);
        return this;
    }

    public inline function lineToPoint(p: Point<Float>):Path2D {
        this.lineTo(p.x, p.y);
        return this;
    }

    public inline function clone():Path2D {
        return new Path2D( this );
    }

/* === Casting Methods === */

    @:from
    public static inline function fromString(s: String):Path2D {
        return new Path2D( s );
    }
}

typedef Path2DInit = Either<NPath, String>;

class Path2DBase {
    /* Constructor Function */
    public function new() {
        segments = new Array();
        currentPoint = null;
        closePoint = null;
        _simple = true;
    }

/* === Instance Methods === */

    function push(seg:Path2DSegment, ?curp:Point<Float>, ?endp:Point<Float>, ?simple:Bool) {
        segments.push( seg );
        if (curp != null)
            currentPoint = curp.clone();

        if (endp != null)
            closePoint = endp.clone();

        if (simple != null)
            _simple = simple;
        return this;
    }

    public function moveTo(x:Float, y:Float) {
        push(Move(x, y), new Point(x, y));
    }

    public function lineTo(x:Float, y:Float) {
        push(Line(x, y), new Point(x, y));
    }

    public function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float) {
        push(Curve(cp1x, cp1y, cp2x, cp2y, x, y), new Point(x, y));
    }

    public function closePath() {
        //push(Close, )
    }

/* === Instance Fields === */

    var segments: Array<Path2DSegment>;
    var currentPoint: Null<Point<Float>> = null;
    var closePoint: Null<Point<Float>> = null;
    var _simple: Bool = true;
}

interface Path2DObject {
    function arc(x:Float, y:Float, radius:Float, startAngle:Float, endAngle:Float, ?antiClockwise:Bool):Void;
    function arcTo(x1:Float, y1:Float, x2:Float, y2:Float, radius:Float):Void;
    function bezierCurveTo(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float):Void;
    function closePath():Void;
    function ellipse(x:Float, y:Float, radiusX:Float, radiusY:Float, rotation:Float, startAngle:Float, endAngle:Float, ?anticlockwise:Bool):Void;
    function lineTo(x:Float, y:Float):Void;
    function moveTo(x:Float, y:Float):Void;
    function quadraticCurveTo(cpx:Float, cpy:Float, x:Float, y:Float):Void;
    function rect(x:Float, y:Float, w:Float, h:Float):Void;
}

enum Path2DSegment {
    Close();
    Move(x:Float, y:Float);
    Line(x:Float, y:Float);
    Curve(cp1x:Float, cp1y:Float, cp2x:Float, cp2y:Float, x:Float, y:Float);
    Arc(rx:Float, ry:Float, fromAngle:Float, extent:Float);

    Ellipse(x:Float, y:Float, radiusX:Float, radiusY:Float, rotation:Float, startAngle:Float, endAngle:Float, anticlockwise:Bool);
    Rect(x:Float, y:Float, w:Float, h:Float);
}
