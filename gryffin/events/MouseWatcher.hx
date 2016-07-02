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
		hovered = new List();

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
		lastMove = e.date;
	}

	/**
	  * handle and the Mouse position falling within the bouds of an Entity
	  */
	private function mouseInEnt(entity:Entity, event:MouseEvent):Void {
		var prev:Bool = entityHovered( entity );
		var curr:Bool = entity.containsPoint( event.position );
		entityHovered(entity, curr);

		switch ([prev, curr]) {
			case [false, true]:
				var mee = event.clone();
				mee.type = 'mouseenter';

				entity.dispatch('mouseenter', mee);

			case [true, false]:
				var mle = event.clone();
				mle.type = 'mouseleave';
				entity.dispatch('mouseleave', mle);

			default:
				null;
		}
	}

	private function hoveredEntities(event : MouseEvent):Void {
		for (entity in hovered) {
			mouseInEnt(entity, event);
		}
	}

	/**
	  * get/set whether the given Entity is registered as 'hovered'
	  */
	private function entityHovered(e:Entity, ?value:Bool):Bool {
		if (value != null) {
			if (value && !hovered.has( e )) {
				hovered.add( e );
			}
			else {
				hovered.remove( e );
			}
			return value;
		}
		else {
			return hovered.has( e );
		}
	}

/* === Computed Instance Fields === */

	private var lastMousePos(get, never):Null<Point>;
	private function get_lastMousePos():Null<Point> {
		if (lastMouseEvent == null) {
			return null;
		}
		else {
			var e = lastMouseEvent;
			switch ( e.type ) {
				case 'mouseleave':
					return null;
				default:
					return e.position;
			}
		}
	}

/* === Instance Fields === */

	private var lastMouseEvent : Null<MouseEvent>;
	private var lastMove : Float;
	private var hovered : List<Entity>;

	public var stage : Stage;
}
