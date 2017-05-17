package gryffin.events;

import gryffin.core.Stage;
import gryffin.core.Entity;

import tannus.events.MouseEvent;
import tannus.geom.Point;

import js.html.MouseEvent in JMEvent;

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
		stage.on('mouseleave', handle);

		_handleMove();
	}

    /**
      * handle mousemove events
      */
	private function _handleMove():Void {
		function _handle(e : JMEvent):Void {
			var pos:Point = stage.globalToLocal(new Point(e.clientX, e.clientY));
			var event:MouseEvent = MouseEvent.fromJsEvent( e );
			event.position = pos;

			lastMouseEvent = event;
			lastMousePos = event.position;
			lastMove = event.date;
		}

        @:privateAccess stage.canvas.canvas.addEventListener('mousemove', _handle);
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
