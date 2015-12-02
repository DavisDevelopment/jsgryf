package gryffin.core;

import tannus.io.Signal;
import tannus.ds.Destructible;
import tannus.events.MouseEvent;
import tannus.events.KeyboardEvent;
import tannus.geom.*;
import tannus.html.Win;

import tannus.nore.Selector;

import gryffin.events.*;
import gryffin.display.Ctx;
import gryffin.core.Entity;
import gryffin.core.EventDispatcher;
import gryffin.fx.Animations;

import js.html.CanvasElement in Canvas;

using Lambda;
using tannus.ds.ArrayTools;

class Stage extends EventDispatcher {
	/* Constructor Function */
	public function new(can : Canvas):Void {
		super();

		canvas = can;
		ctx = canvas.getContext2d();
		children = new Array();
		manager = new FrameManager();
		mouseManager = new MouseListener( this );
		keyManager = new KeyListener( this );
		mouseWatcher = new MouseWatcher( this );
		eventTimes = new Map();

		_fill = false;
		lastWindowSize = window.viewport;

		__init();
	}

/* === Instance Methods === */

	/**
	  * Resize [this] Stage
	  */
	public function resize(w:Int, h:Int):Void {
		canvas.width = w;
		canvas.height = h;
		ctx = canvas.getContext2d();
	}

	/**
	  * Append some Entity to [this] Stage
	  */
	public function addChild(child : Entity):Void {
		if (!children.has( child )) {
			children.push( child );
			child.stage = this;
			child.dispatch('activated', this);
		}
	}

	/**
	  * Cause the Canvas to scale to fit the Window
	  */
	public function fill():Void {
		_fill = true;
	}

	/**
	  * Get the last known position of the cursor
	  */
	public function getMousePosition():Point {
		return mouseWatcher.getMousePosition();
	}

	/**
	  * Get the time of the most recent occurrence of the given event
	  */
	public function mostRecentOccurrenceTime(event : String):Null<Float> {
		return eventTimes.get( event );
	}

	/**
	  * Function run each frame
	  */
	private function frame(delta : Float):Void {
		/*
		   if the [_fill] attribute is `true`, 
		   and the size of the Window has changed,
		   scale the Canvas to fit the Window
		*/
		if ( _fill ) {
			var vp = window.viewport;
			if (vp != lastWindowSize) {
				StageFiller.sheet();
				canvas.width = (Std.int( vp.w ));
				canvas.height = (Std.int( vp.h ));
				lastWindowSize = vp;
			}
		}

		/* remove those Entities which have been marked for deletion */
		children = children.filter(function(e) return !e.destroyed);

		/* sort the Entities by priority */
		haxe.ds.ArraySort.sort(children, function(a:Entity, b:Entity) {
			return (a.priority - b.priority);
		});

		/* clear the Canvas */
		ctx.erase();

		/* for every Entity on [this] Stage */
		for (child in children) {
			// if it not cached
			if (!child._cached) {
				// update it
				child.update( this );
			}

			// if it is not hidden
			if (!child._hidden) {
				// render it
				child.render(this, ctx);
			}
		}

		/* if we're managing Animations */
		if ( Animations.manager == this ) {
			Animations.tick();
		}
	}

	/**
	  * Walk [children], getting child-nodes of Containers as well
	  */
	private function walk(?childList:Array<Entity>, ?ignore:Entity->Bool):Array<Entity> {
		if (childList == null)
			childList = children;
		var results:Array<Entity> = childList;
		
		for (child in childList) {
			if (ignore != null && ignore(child)) {
				continue;
			}
			if (Std.is(child, EntityContainer)) {
				var container:EntityContainer = cast child;
				results = results.concat(walk( container.children ));
			}
		}

		return results;
	}

	/**
	  * Query [this] Stage
	  */
	public function get<T:Entity>(sel : String):Array<T> {
		if (selectorCache.exists( sel )) {
			return selectorCache.get( sel ).filter(untyped walk());
		}
		else {
			var s:Selector = new Selector( sel );
			selectorCache.set(sel, s);
			return s.filter(untyped walk());
		}
	}

	/**
	  * Handle a MouseEvent
	  */
	private function mouseEvent(e : MouseEvent):Void {
		dispatch(e.type, e);

		/* ignore items that are cached or hidden */
		var ignore = (function(e:Entity) return (e._cached || e._hidden));

		/* pre-fetch the list of Entities to be processed */
		var ents = walk(null, ignore);

		/* reverse [children] so that the topmost Entity will become the target */
		ents.reverse();

		/* find the target */
		var target:Null<Entity> = null;
		for (child in ents) {
			if (child.containsPoint(e.position)) {
				child.dispatch(e.type, e);
				target = child;
				break;
			}
		}
	}

	/**
	  * Initialize [this] Stage
	  */
	private function __init():Void {
		__events();
		Animations.claim( this );
	}

	/**
	  * Initialize all Event Managing Objects
	  */
	private function __events():Void {
		manager.frame.on( frame );
		manager.start();
	}

	/**
	  * Store the times at which events occur
	  */
	override public function dispatch<T>(name:String, data:T):Void {
		super.dispatch(name, data);
		eventTimes.set(name, Date.now().getTime());
	}

/* === Computed Instance Fields === */

	/* the width of [this] Stage */
	public var width(get, set):Int;
	private inline function get_width() return canvas.width;
	private function set_width(v : Int):Int {
		resize(v, height);
		return width;
	}

	/* the height of [this] Stage */
	public var height(get, set):Int;
	private inline function get_height() return canvas.height;
	private function set_height(v : Int):Int {
		resize(width, v);
		return height;
	}

	/* the rectangle of [this] Stage */
	public var rect(get, set):Rectangle;
	private inline function get_rect():Rectangle {
		return new Rectangle(0, 0, width, height);
	}
	private inline function set_rect(v : Rectangle):Rectangle {
		resize(Math.round(v.w), Math.round(v.h));
		return rect;
	}

/* === Instance Fields === */

	public var canvas : Canvas;
	public var ctx : Ctx;
	public var children : Array<Entity>;

	private var manager : FrameManager;
	private var mouseManager : MouseListener;
	private var keyManager : KeyListener;
	private var mouseWatcher : MouseWatcher;

	/* dictates whether or not to scale the Canvas to fit the window */
	private var _fill : Bool;
	
	/* the last known dimensions of the Window */
	private var lastWindowSize : Rectangle;
	private var eventTimes : Map<String, Float>;

/* === Static Fields === */

	/**
	  * The current Window object
	  */
	private static var window(get, never):Win;
	private static inline function get_window():Win {
		return Win.current;
	}

	/* the cached Selectors */
	private static var selectorCache:Map<String, Selector> = {new Map();};
}
