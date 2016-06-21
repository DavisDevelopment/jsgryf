package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;

import Math.*;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class Label extends Panel {
	/* Constructor Function */
	public function new():Void {
		super();

		tb = new TextBox();
	}

/* === Instance Methods === */

	/**
	  * render [this] Label
	  */
	override public function renderContent(s:Stage, c:Ctx, r:Rectangle):Void {
		super.renderContent(s, c, r);

		tb.fontFamily = styles.font.family;
		tb.fontSize = styles.font.size;
		tb.fontSizeUnit = styles.font.sizeUnit;
		tb.color = styles.color;

		c.drawComponent(tb, 0, 0, tb.width, tb.height, r.x, r.y, tb.width, tb.height);
	}

	/* get the width */
	override private function get_w():Float {
		return max(super.get_w(), contentWidth());
	}
	override private function set_w(v : Float):Float {
		v -= (styles.padding.horizontal + (styles.border.width * 2));
		return super.set_w(max(v, contentWidth()));
	}

	/* the height */
	override public function get_h():Float {
		return max(super.get_h(), contentHeight());
	}
	override public function set_h(v : Float):Float {
		v -= (styles.padding.vertical + (styles.border.width * 2));
		return super.set_h(max(v, contentHeight()));
	}

	private inline function contentWidth():Float {
		return (tb.width + styles.padding.horizontal + (styles.border.width * 2));
	}
	private inline function contentHeight():Float {
		return (tb.height + styles.padding.vertical + (styles.border.width * 2));
	}

/* === Instance Methods === */

	/* the text displayed by [this] Label */
	public var text(get, set):String;
	private inline function get_text():String return tb.text;
	private inline function set_text(v : String):String return (tb.text = v);

/* === Instance Fields === */

	private var tb : TextBox;
}
