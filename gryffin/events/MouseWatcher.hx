package gryffin.events;

import gryffin.core.Stage;
import gryffin.core.Entity;

import tannus.events.MouseEvent;
import tannus.geom.Point;

using Lambda;

class MouseWatcher {
	/* Constructor Function */
	public function new(s : Stage):Void {
		stage = s;
		lastMouseEvent = null;
		lastMove = -1;

		_listen();
	}

/* === Instance Methods === */

	/**
	  * get the last known mouse-position
	  */
	public function getMousePosition():Null<Point> {
		return (lastMousePos == null ? null : lastMousePos.clone());
	}

	/**
	  * get the time of the most recent mouse movement
	  */
	public function getMoveTime():Null<Float> {
		return (lastMove != -1 ? lastMove : null);
	}

	/**
	  * get the last MouseEvent
	  */
	public function getLastEvent():Null<MouseEvent> {
		return lastMouseEvent;
	}

	/**
	  * Register event handlers
	  */
	private function _listen():Void {
		stage.on('mousemove', handle);
		stage.on('mouseleave', handle);
	}

	/**
	  * Handle the mousemove event
	  */
	private function handle(e : MouseEvent):Void {
		lastMouseEvent = e;
		lastMousePos = e.position;
		lastMove = e.date;
	}

/* === Computed Instance Fields === */

/* === Instance Fields === */

	private var lastMouseEvent : Null<MouseEvent>;
	private var lastMousePos : Null<Point>;
	private var lastMove : Float;

	public var stage : Stage;
}
