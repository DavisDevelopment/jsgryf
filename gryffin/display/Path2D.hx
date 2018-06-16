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

    public inline function addRect(rect: Rect<Float>):Path2D {
        this.rect(rect.x, rect.y, rect.width, rect.height);
        return this;
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
