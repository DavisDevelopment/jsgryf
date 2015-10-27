package gryffin.events;

import gryffin.Tools.*;
import js.Browser.window;

import tannus.io.Signal;

class FrameManager {
	/* Constructor Function */
	public function new():Void {
		frame = new Signal();
	}

/* === Instance Methods === */

	/**
	  * Fuction fired each frame
	  */
	private function _frame(delta : Float):Void {
		frame.call( delta );
		queueNext();
	}

	/**
	  * Start [this] Loop
	  */
	private function queueNext():Void {
		id = window.requestAnimationFrame( _frame );
	}

	/**
	  * Start [this] Loop
	  */
	public function start():Void {
		queueNext();
	}

	/**
	  * Stop [this] Loop
	  */
	public function stop():Void {
		window.cancelAnimationFrame( id );
	}

/* === Instance Fields === */

	public var frame : Signal<Float>;
	private var id : Int;
}
