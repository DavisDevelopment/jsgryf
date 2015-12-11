package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

class Page extends EntityContainer {
	/* Constructor Function */
	public function new():Void {
		super();

		_opened = false;
		prev_page = null;
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

/* === Instance Fields === */

	/* whether [this] Page is currently opened */
	private var _opened : Bool;

	/* the Page that was opened, when [this] one */
	private var prev_page : Null<Page>;
}
