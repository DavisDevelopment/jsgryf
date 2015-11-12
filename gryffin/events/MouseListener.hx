package gryffin.events;

import gryffin.core.*;

import tannus.events.MouseEvent;
import tannus.events.EventCreator;
import tannus.events.EventMod;
import tannus.html.Win;
import tannus.geom.Point;

import js.html.CanvasElement in Canvas;
import js.html.MouseEvent in JMEvent;

@:access(gryffin.core.Stage)
class MouseListener implements EventCreator {
	/* Constructor Function */
	public function new(s : Stage):Void {
		stage = s;
		canvas = stage.canvas;

		bind();
	}

/* === Instance Methods === */

	/**
	  * Listen for events on the thing
	  */
	private function bind():Void {
		var relevant = ['click', 'mouseup', 'mousedown'];
		for (name in relevant) {
			canvas.addEventListener(name, handle);
		}
		canvas.addEventListener('mousemove', handleMove);
	}

	/**
	  * Find the coordinates of the given mouse-event, relative to the Canvas
	  */
	private function findPos(e : JMEvent):Point {
		var pos:Point = new Point(e.clientX, e.clientY);
		var crect = canvas.getBoundingClientRect();
		
		pos.x -= crect.left;
		pos.y -= crect.top;

		return pos;
	}

	/**
	  * Get the modifiers of a given mouse-event
	  */
	private function findMods(e : JMEvent):Array<EventMod> {
		var mods:Array<EventMod> = new Array();
		if (e.altKey)
			mods.push(Alt);
		if (e.ctrlKey)
			mods.push(Control);
		if (e.shiftKey)
			mods.push(Shift);
		if (e.metaKey)
			mods.push(Meta);
		return mods;
	}

	/**
	  * Handle an incoming MouseEvent
	  */
	private function handle(e : JMEvent):Void {
		var pos:Point = findPos( e );
		var mods = findMods( e );
		var event:MouseEvent = new MouseEvent(e.type, pos, e.button, mods);
		event.onDefaultPrevented.once(untyped e.preventDefault);
		event.onPropogationStopped.once(untyped e.stopPropagation);
		stage.mouseEvent( event );
	}

	/**
	  * Handle mouse movement
	  */
	private function handleMove():Void {
		var lastTarget:Null<Entity> = null;
		function _handle(e : JMEvent):Void {
			var pos:Point = findPos( e );
			var mods = findMods( e );
			var event:MouseEvent = new MouseEvent(e.type, pos, e.button, mods);
			event.onDefaultPrevented.once(untyped e.preventDefault);
			event.onPropogationStopped.once(untyped e.stopPropagation);

			var target = getRootTarget( event );
			switch ([lastTarget, target]) {
				/* == mouseenter == */
				case [null, entered]:
					entered.dispatch('mouseenter', e);

				/* == mouseleave == */
				case [left, null]:
					left.dispatch('mouseleave', e);

				/* == mousemove == */
				case [left, right]:
					/* == moved within the same entity == */
					if (left == right) {
						left.dispatch('mousemove', e);
					}

					else {
						left.dispatch('mouseleave', e);
						right.dispatch('mouseenter', e);
					}
			}
			lastTarget = target;
			stage.mouseEvent( event );
		}

		canvas.addEventListener('mousemove', _handle);
	}

	/**
	  * get the root event target
	  */
	private function getRootTarget(e : MouseEvent):Null<Entity> {
		for (child in stage.children) {
			if (child.containsPoint(e.position) && !(child._cached || child.destroyed)) {
				return child;
			}
		}
		return null;
	}

/* === Instance Fields === */

	public var stage : Stage;
	public var canvas : Canvas;
}
