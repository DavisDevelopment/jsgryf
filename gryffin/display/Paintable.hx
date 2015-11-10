package gryffin.display;

import gryffin.display.Ctx;

import tannus.geom.Rectangle;

/**
  * interface for an Object which can be drawn onto a Canvas
  */
interface Paintable {
	function paint(c:Ctx, src:Rectangle, dest:Rectangle):Void;
}
