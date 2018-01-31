package gryffin.display;

import gryffin.display.Ctx;

import tannus.geom2.Rect;

/**
  * interface for an Object which can be drawn onto a Canvas
  */
interface Paintable {
	function paint(c:Ctx, src:Rect<Float>, dest:Rect<Float>):Void;
}
