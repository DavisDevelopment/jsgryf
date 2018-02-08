package gryffin.display;

import tannus.ds.Ref;
import tannus.geom2.*;
import tannus.io.ByteArray;
import tannus.io.Blob;
import tannus.html.Blobable;
import tannus.html.Win;

import gryffin.display.Ctx;
import gryffin.display.Context;
import gryffin.display.Paintable;

import js.html.CanvasElement in NCanvas;
import js.Browser.window;
import js.Browser.document in doc;
import js.html.Blob in JBlob;
import js.html.FileReader;
import js.html.MediaStream;

import Math.*;
import tannus.math.TMath.*;

using StringTools;
using tannus.ds.StringUtils;
using Slambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;
using tannus.FunctionTools;
using tannus.html.JSTools;

class OffscreenCanvas extends Canvas {
    /* Constructor Function */
    public function new(?c: Dynamic):Void {
        super( c );
        if (!(untyped __instanceof__(c, __js__('OffscreenCanvas')))) {
            throw 'TypeError: [$c] is not an OffscreenCanvas';
        }
    }

/* === Instance Methods === */

    /**
      * create a new OffscreenCanvas
      */
    override function _makeCanvas():Dynamic {
        return untyped Type.createInstance((untyped __js__('OffscreenCanvas')), [0, 0]);
    }

    /**
      * commit [this] OffscreenCanvas to its non-Offscreen counterpart
      */
    public inline function commit():Void {
        (untyped canvas).commit();
    }

/* === Statics === */

    /**
      * create and return a new OffscreenCanvas with the given width and height
      */
    public static inline function create(width:Int, height:Int):OffscreenCanvas {
        return new OffscreenCanvas(untyped __js__('new OffscreenCanvas({0}, {1})', width, height));
    }
}
