package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.events.*;
import tannus.io.Ptr;
import tannus.io.Getter;
import tannus.math.Percent;

import Math.*;
import tannus.math.TMath.*;

using tannus.math.TMath;

class ScrollBar extends Entity {
	/* Constructor Function */
	public function new(cr:Getter<Rectangle>, vp:Getter<Rectangle>, sy:Ptr<Float>):Void {
		super();

		priority = 90;

		_cr = cr;
		_vp = vp;
		_scroll = sy;
	}

/* === Instance Methods === */

	/**
	  * determine whether [this] is needed
	  */
	public function needed():Bool {
		return (content.h > viewport.h);
	}

	/**
	  * determine whether a given Point lies within [this]
	  */
	override public function containsPoint(p : Point):Bool {
		return track.containsPoint( p );
	}

	/**
	  * render [this] ScrollBar
	  */
	override public function render(stage:Stage, c:Ctx):Void {
		if (needed()) {
			c.save();
			c.fillStyle = '#F1F1F1';
			c.beginPath();
			c.drawRect( track );
			c.closePath();
			c.fill();

			c.fillStyle = '#C2C2C2';
			c.beginPath();
			c.drawRect( bar );
			c.closePath();
			c.fill();
			c.restore();
		}
	}

/* === Computed Instance Fields === */

	/* the content rectangle */
	public var content(get, never):Rectangle;
	private inline function get_content():Rectangle return _cr;

	/* the viewport rectangle */
	public var viewport(get, never):Rectangle;
	private inline function get_viewport():Rectangle return _vp;

	/* the scroll-position */
	public var scroll(get, set):Float;
	private inline function get_scroll():Float return _scroll.get();
	private inline function set_scroll(v : Float):Float return _scroll.set( v );

	/* the track-rect */
	public var track(get, never):Rectangle;
	private function get_track():Rectangle {
		var w = 20;
		var vp = viewport;
		return new Rectangle((vp.x + vp.w - w), vp.y, w, vp.h);
	}

	/* the bar-rect */
	public var bar(get, never):Rectangle;
	private function get_bar():Rectangle {
		var vp = viewport;
		var cr = content;
		var t = track;
		var diff = (cr.h - vp.h);
		var vpp = Percent.percent(vp.h, cr.h);
		var bh = vpp.of( t.h );
		var sp = Percent.percent(scroll, diff);
		return new Rectangle(t.x, sp.of(t.h), t.w, bh);
	}

/* === Instance Fields === */

	private var _cr : Getter<Rectangle>;
	private var _vp : Getter<Rectangle>;
	private var _scroll : Ptr<Float>;
}
