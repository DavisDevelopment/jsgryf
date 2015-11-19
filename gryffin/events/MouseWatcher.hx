package gryffin.events;

import gryffin.core.Stage;

import tannus.events.MouseEvent;
import tannus.geom.Point;

class MouseWatcher {
	/* Constructor Function */
	public function new(s : Stage):Void {
		stage = s;
		lastMousePos = null;
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
	  * Register event handlers
	  */
	private function _listen():Void {
		stage.on('mousemove', onmove);
		stage.on('mouseleave', onleave);
	}

	/**
	  * Handle the mousemove event
	  */
	private function onmove(e : MouseEvent):Void {
		lastMousePos = e.position;
		lastMove = e.date;
	}

	/**
	  * handle the mouseleave event
	  */
	private function onleave(e : MouseEvent):Void {
		lastMousePos = null;
	}

/* === Instance Fields === */

	private var lastMousePos : Null<Point>;
	private var lastMove : Float;

	public var stage : Stage;
}
