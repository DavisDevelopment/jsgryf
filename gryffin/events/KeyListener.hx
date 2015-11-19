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

		listen();
	}

/* === Instance Methods === */

	/**
	  * Listen for keyboard events on the Stage
	  */
	public function listen():Void {
		var win:Win = Win.current;
		var events:Array<String> = ['keydown', 'keyup', 'keypress'];
		for (name in events) {
			win.addEventListener(name, handle);
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
