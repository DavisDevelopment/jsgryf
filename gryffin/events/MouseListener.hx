package gryffin.events;

import gryffin.core.*;

import tannus.events.MouseEvent;
import tannus.events.ScrollEvent;
import tannus.events.EventCreator;
import tannus.events.EventMod;
import tannus.html.Win;
import tannus.geom2.Point;

import js.html.CanvasElement in Canvas;
import js.html.MouseEvent in JMEvent;
import js.html.WheelEvent in JWEvent;

@:access( gryffin.core.Stage )
@:access( gryffin.display.Canvas )
class MouseListener implements EventCreator {
	/* Constructor Function */
	public function new(s : Stage):Void {
		stage = s;
		relevant = ['click', 'mouseup', 'mousedown', 'mouseenter', 'mouseleave', 'mousemove', 'contextmenu', 'wheel'];

		bind();
	}

/* === Instance Methods === */

	/**
	  * Listen for events on the thing
	  */
	private function bindMouse():Void {
		var relevant = this.relevant.slice(0, 4);
		trace( relevant );
		for (name in relevant) {
			canvas.addEventListener(name, handle);
		}
		canvas.addEventListener('mousemove', handleMove);

		canvas.addEventListener('contextmenu', handleMenu);
	}

	private function dragEvent(event : Dynamic):Void {
		//var ev = DragEvent.fromDOMEvent(cast event);
		var ev = MouseEvent.fromJsEvent(cast event);
		ev.position = findPos(cast event);
		
		stage.mouseEvent( ev );
	}

	/**
	  * Listen for mouse-wheel events
	  */
	private function bindWheel():Void {
		canvas.addEventListener('wheel', handleWheel);
	}

	/**
	  * Handle ContextMenu Event
	  */
	private function handleMenu(e : JMEvent):Void {
		var event:MouseEvent = new MouseEvent(e.type, findPos( e ), e.button, findMods( e ));

		function prevent():Void {
			e.preventDefault();
		}

		event.onCancelled.once( prevent );
		event.onDefaultPrevented.once( prevent );
		event.onPropogationStopped.once( prevent );

		stage.mouseEvent( event );
	}

	/**
	  * Listen for events
	  */
	private function bind():Void {
		bindMouse();
		bindWheel();
	}

	/**
	  * Stop listening for events
	  */
	public function unbind():Void {
		for (name in relevant) {
			canvas.removeEventListener(name, handle);
		}
		canvas.removeEventListener('mousemove', handleMove);
		canvas.removeEventListener('contextmenu', handleMenu);
		canvas.removeEventListener('mousewheel', handleWheel);
	}

	/**
	  * Rebind events
	  */
	public function rebind():Void {
		unbind();
		bind();
	}

	/**
	  * Find the coordinates of the given mouse-event, relative to the Canvas
	  */
	private inline function findPos(e : JMEvent):Point<Float> {
		return stage.globalToLocal(new Point(e.clientX, e.clientY).float());
	}

	/**
	  * Get the modifiers of a given mouse-event
	  */
	private function findMods(e : JMEvent):Array<EventMod> {
		var mods:Array<EventMod> = new Array();
		if ( e.altKey )
			mods.push( Alt );
		if ( e.ctrlKey )
			mods.push( Control );
		if ( e.shiftKey )
			mods.push( Shift );
		if ( e.metaKey )
			mods.push( Meta );
		return mods;
	}

	/**
	  * Handle an incoming MouseEvent
	  */
	private function handle(e : JMEvent):Void {
		var pos:Point<Float> = findPos( e );
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
			var pos:Point<Float> = findPos( e );
			var mods = findMods( e );
			var event:MouseEvent = new MouseEvent(e.type, pos, e.button, mods);
			event.onDefaultPrevented.once(untyped e.preventDefault);
			event.onPropogationStopped.once(untyped e.stopPropagation);

			//stage.mouseEvent( event );
			stage.dispatch('mousemove', event);
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

	/**
	  * Handle mouse wheen events
	  */
	private function handleWheel(e : JWEvent):Void {
		var delta:Int = Std.int(Math.max(-1, Math.min(1, -e.deltaY)));
		var event:ScrollEvent = new ScrollEvent( delta );
		stage.dispatch('scroll', event);
	}

/* === Computed Instance Fields === */

	/* the Canvas Element itself */
	private var canvas(get, never):Canvas;
	private inline function get_canvas():Canvas return stage.canvas.canvas;

/* === Instance Fields === */

	public var stage : Stage;
	private var relevant : Array<String>;
}
