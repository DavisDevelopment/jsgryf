package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;

import Math.*;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class LayoutElement extends Ent {
	/* Constructor Function */
	public function new():Void {
		super();

		styles = new LayoutStyles( this );
		manager = new LayoutManager( this );
	}

/* === Instance Methods === */

	/**
	  * get the children of [this] that are LayoutElements
	  */
	public function getElements():Array<LayoutElement> {
		return cast getChildren().macfilter(Std.is(_, LayoutElement));
	}

	/**
	  * get the position of [this] Element, relative to the Stage
	  */
	public function getGlobalPosition():Point {
		var p:Point = pos.clone();
		var ctx = layoutParent;
		while (ctx != null) {
			p = p.plusPoint( ctx.pos );
			p.x += ctx.styles.padding.left;
			p.y += ctx.styles.padding.top;
			
			ctx = ctx.layoutParent;
		}
		return p;
	}

	/**
	  * get [this] Element's Rectangle, relative to the Stage
	  */
	public function getGlobalRectangle():Rectangle {
		var r = rect.clone();
		r.position = getGlobalPosition();
		return r;
	}

	/**
	  * get the Rectangle of the Container that [this] is in
	  */
	public function getContainerRectangle():Rectangle {
		if (layoutParent == null) {
			return stage.rect;
		}
		else {
			return layoutParent.getGlobalRectangle();
		}
	}

	/**
	  * calculate layout
	  */
	public function calculateMetrics():Void {
		manager.recalc();
	}

	/**
	  * Check whether the given Point is inside of [this]'s Rectangle
	  */
	override public function containsPoint(p : Point):Bool {
		return getGlobalRectangle().containsPoint( p );
	}
	
	override public function addChild(e : Entity):Void {
		super.addChild( e );

		if (Std.is(e, LayoutElement)) {
			calculateMetrics();
		}
	}

	override private function get_pos():Point {
		if (row == null) {
			return new Point(x, y);
		}
		else {
			return row.pos;
		}
	}

/* === Computed Instance Fields === */

	/* the parent of [this] Entity, as a LayoutElement */
	public var layoutParent(get, never):Null<LayoutElement>;
	private inline function get_layoutParent():Null<LayoutElement> return ((parent != null && Std.is(parent, LayoutElement)) ? cast parent : null);

	/* the root LayoutElement */
	public var layoutRoot(get, never):Null<LayoutElement>;
	private function get_layoutRoot():Null<LayoutElement> {
		var r = this;
		while (r.layoutParent != null)
			r = r.layoutParent;
		return r;
	}

	/* the Row that [this] Element is in */
	public var row(get, never):Null<LayoutRow>;
	private function get_row():Null<LayoutRow> {
		if (_row == null && layoutParent != null) {
			_row = layoutParent.manager.getContainingRow( this );
		}
		return _row;
	}

/* === Instance Fields === */

	public var styles : LayoutStyles;
	public var manager : LayoutManager;
	private var _row : Null<LayoutRow> = null;
}
