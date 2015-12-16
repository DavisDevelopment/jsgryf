package gryffin.ui;

import tannus.geom.*;
import tannus.events.ScrollEvent;

import gryffin.core.*;
import gryffin.display.*;

class Page extends EntityContainer {
	/* Constructor Function */
	public function new():Void {
		super();

		_opened = false;
		prev_page = null;
		scrollY = 0;
		viewport = new Rectangle();

		on('scroll', scroll);
	}

/* === Instance Methods === */

	/**
	  * Open [this] Page
	  */
	public function open():Void {
		if (stage != null) {
			var pages:Selection<Page> = stage.get('~gryffin.ui.Page:_opened');
			if (pages.length > 0) {
				prev_page = pages.at(0);
				prev_page.close();
			}

			_opened = true;
			dispatch('open', null);
		}
		else {
			throw 'PageError: Cannot open Page before it is activated!';
		}
	}

	/**
	  * Close [this] Page
	  */
	public function close():Void {
		_opened = false;
		dispatch('close', null);
	}

	/**
	  * Check if [this] Page is currently open
	  */
	public function isOpen():Bool {
		return _opened;
	}

	/**
	  * Update [this] Page
	  */
	override public function update(s : Stage):Void {
		if ( isOpen() ) {
			super.update( s );
			viewport = new Rectangle(0, 0, s.width, s.height);
		}
	}

	/**
	  * Render [this] Page
	  */
	override public function render(s:Stage, c:Ctx):Void {
		if ( isOpen() ) {
			super.render(s, c);
		}
	}

	/**
	  * scroll [this] Page
	  */
	private function scroll(e : ScrollEvent):Void {
		scrollY += e.delta;
	}

	/**
	  * get all children of [this] Page which 'contain' the given Point
	  */
	override public function getEntitiesAtPoint(p : Point):Array<Entity> {
		if (isOpen()) {
			return super.getEntitiesAtPoint(p);
		}
		else {
			return new Array();
		}
	}

	/**
	  * check whether [p] is inside our content rectangle
	  */
	override public function containsPoint(p : Point):Bool {
		return contentRect.containsPoint( p );
	}

/* === Instance Methods === */

	/* the rectangle occupied by the content of [this] Page */
	public var contentRect(get, never):Rectangle;
	private function get_contentRect():Rectangle {
		return new Rectangle();
	}

/* === Instance Fields === */

	/* whether [this] Page is currently opened */
	private var _opened : Bool;

	/* the Page that was opened, when [this] one */
	private var prev_page : Null<Page>;

	/* the viewport rectangle */
	public var viewport : Rectangle;

	/* the offset from 0 of [this]'s scroll-position */
	public var scrollY : Float;
}
