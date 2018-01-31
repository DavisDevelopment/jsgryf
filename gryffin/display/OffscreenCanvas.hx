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
    public function new(width:Int, height:Int):Void {
        super(untyped Type.createInstance(window.nativeArrayGet('OffscreenCanvas'), [width, height]));
    }
}
