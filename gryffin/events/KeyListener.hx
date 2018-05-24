package gryffin.events;

import tannus.events.KeyboardEvent;
import tannus.events.EventMod;
import tannus.events.EventCreator;
import tannus.html.Win;

import js.html.KeyboardEvent in NEvent;

import gryffin.core.Stage;

class KeyListener implements EventCreator {
	/* Constructor Function */
	public function new(s : Stage):Void {
		stage = s;

		//listen();
	}

/* === Instance Methods === */

	/**
	  * Listen for keyboard events on the Stage
	  */
	var _ubh:NEvent->Void = null;
	var events:Array<String> = {['keydown', 'keyup', 'keypress'];};
	public function bind():Void {
		var win:Win = Win.current;
		//var events:Array<String> = 
		if (_ubh == null)
		    _ubh = handle.bind();
        else return ;

		for (name in events) {
			win.addEventListener(name, _ubh);
		}
	}

	public function unbind() {
	    if (_ubh != null) {
	        for (e in events) {
	            Win.current.removeEventListener(e, _ubh);
	        }
	        _ubh = null;
	    }
	}

	/**
	  * Get the modifiers from a KeyboardEvent
	  */
	private function collectMods(e : NEvent):Array<EventMod> {
		var mods:Array<EventMod> = new Array();
		if ( e.altKey )
			mods.push( Alt );
		if ( e.shiftKey )
			mods.push( Shift );
		if ( e.ctrlKey )
			mods.push( Control );
		if ( e.metaKey )
			mods.push( Meta );
		return mods;
	}

	/**
	  * Handle incoming Keyboard Event
	  */
	private function handle(e : NEvent):Void {
		var event:KeyboardEvent = new KeyboardEvent(e.type, e.keyCode, collectMods(e));
		event.onDefaultPrevented.once(untyped e.preventDefault);
		event.onPropogationStopped.once(untyped e.stopPropagation);
		stage.dispatch(e.type, event);
	}

/* === Instance Fields === */

	public var stage : Stage;
}
