package gryffin.core;

import tannus.io.Signal;
import tannus.io.Getter;
import tannus.ds.Destructible;
import tannus.ds.Delta;
import tannus.events.*;
import tannus.geom.*;
import tannus.html.Win;

import tannus.nore.Selector;

import gryffin.events.*;
import gryffin.display.Ctx;
import gryffin.display.Canvas;
import gryffin.core.Entity;
import gryffin.core.EventDispatcher;
import gryffin.fx.Animations;

import js.html.CanvasElement in NativeCanvas;
import gryffin.Tools.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

@:access( gryffin.display.Canvas )
class Stage extends EventDispatcher implements Container {
	/* Constructor Function */
	public function new(can : NativeCanvas):Void {
		super();

		canvas = new Canvas( can );
		children = new Array();
		registry = new Map();
		styles = new GlobalStyles( this );
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
	  * Re-attach [this] Stage to another Canvas
	  */
	public function attach(can : NativeCanvas):Void {
		canvas = new Canvas( can );
		mouseManager.rebind();
	}

	/**
	  * Resize [this] Stage
	  */
	public function resize(w:Int, h:Int):Void {
		var _w:Int = width;
		var _h:Int = height;
		canvas.width = w;
		canvas.height = h;
		
		if (!(width == _w && height == _h)) {
			var o = new Area(_w, _h);
			var n = new Area(width, height);
			var event = new ResizeEvent(o, n);
			dispatch('resize', event);
		}

		calculateGeometry();
	}

	/**
	  * Append some Entity to [this] Stage
	  */
	public function addChild(child : Entity):Void {
		if (!children.has( child )) {
			children.push( child );
			registry[child.id] = child;
			child.stage = this;
			child.dispatch('activated', this);
		}
	}

	/**
	  * Check whether [child] is a child of [this] Stage
	  */
	public function hasChild(child : Entity):Bool {
		return children.has( child );
	}

	/**
	  * Cause the Canvas to scale to fit the Window
	  */
	public function fill():Void {
		_fill = true;
		styles.fill();
	}

	/**
	  * Load a custom font-face
	  */
	public function loadFontFace(family:String, source:String):Void {
		styles.addFont(family, source);
	}

	/**
	  * Check whether the given font-face has been loaded
	  */
	public function isFontFaceLoaded(family : String):Bool {
		return styles.hasFont( family );
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
	  * Get a list of entities that reported themselves to overlap with the given coords
	  */
	public function getEntitiesAtPoint(p:Point, ?list:Array<Entity>):Array<Entity> {
		/*
		var res:Array<Entity> = new Array();
		if (list == null) {
			list = children;
		}
		for (e in list) {
			if (e.containsPoint( p )) {
				res.push( e );
				
				if (Std.is(e, EntityContainer)) {
					var c:EntityContainer = cast e;
					var cl = cast(e, EntityContainer).getEntitiesAtPoint( p );
					trace( cl.length );
					res = res.concat( cl );
				}
			}
		}
		return res;
		*/
		return walk().macfilter(_.containsPoint( p ));
	}
	public inline function getEntitiesAt(x:Float, y:Float):Array<Entity> return getEntitiesAtPoint(new Point(x, y));

	/**
	  * Get the 'first' Entity which reported itself to overlap with the given Point
	  */
	public function getEntityAtPoint(p : Point):Null<Entity> {
		var start = now;
		var target:Null<Entity> = null;
		children.reverse();
		for (e in children) {
			if (e.containsPoint( p )) {
				target = e;
				if (Std.is(e, EntityContainer)) {
					var c:EntityContainer = cast e;
					var etarget:Null<Entity> = c.getEntityAtPoint( p );
					if (etarget != null)
						target = etarget;
				}
				break;
			}
		}
		children.reverse();
		var took = (now - start);
		return target;
		/*
		var start = now;
		var l = getEntitiesAtPoint( p );
		trace( l );
		var target = l.macmax( _.priority );
		var took = (now - start);
		return target;
		*/
	}
	public function getEntityAt(x:Float, y:Float):Null<Entity> {
		return getEntityAtPoint(new Point(x, y));
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
				var cw:Int = (Std.int( vp.w ));
				var ch:Int = (Std.int( vp.h ));
				resize(cw, ch);
				lastWindowSize = vp;
			}
		}

		/* reset the cursor to the default (arrow) */
		// cursor = 'default';

		/* remove those Entities which have been marked for deletion */
		var filtr = children.splitfilter(function(e) return !e.destroyed);
		for (ent in filtr.fail) {
			registry.remove( ent.id );
		}
		children = filtr.pass;

		/* sort the Entities by priority */
		haxe.ds.ArraySort.sort(children, function(a:Entity, b:Entity) {
			return (a.priority - b.priority);
		});

		/* clear the Canvas */
		if ( !noclear ) {
			ctx.erase();
		}

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
	  * Calculate geometry
	  */
	public function calculateGeometry():Void {
		var vp = rect;
		for (e in children) {
			e.calculateGeometry( vp );
		}
	}

	/**
	  * Walk [children], getting child-nodes of Containers as well
	  */
	private function walk(?list:Array<Entity>, ?ignore:Entity->Bool):Array<Entity> {
		if (list == null) {
			list = children;
		}
		var res:Array<Entity> = new Array();
		for (ent in list) {
			if (ignore != null && ignore( ent )) {
				continue;
			}
			else {
				res.push( ent );
				res = res.concat(walk(ent.getChildren(), ignore));
			}
		}

		return res;
	}

	/**
	  * Create a DOM-like tree-representation of [this]'s children
	  */
	public function tree(?list:Array<Dynamic>, ?kids:Array<Entity>):Array<Dynamic> {
		if (list == null)
			list = new Array();
		if (kids == null)
			kids = children;
		kids.reverse();
		for (child in kids) {
			if (Std.is(child, EntityContainer)) {
				var c:EntityContainer = cast child;
				var sub = tree(list, c.getChildren());
				list.push(untyped [child, sub]);
			}
			else {
				list.push( child );
			}
		}
		kids.reverse();
		return list;
	}

	/**
	  * Query [this] Stage
	  */
	public function get<T:Entity>(sel : String):Selection<T> {
		return new Selection(sel, untyped Getter.create( walk() ));
	}

	/**
	  * Handle a MouseEvent
	  */
	private function mouseEvent(e : MouseEvent):Void {
		// dispatch the event on [this] Stage
		dispatch(e.type, e);

		/* if the event has been cancelled, or has ceased propogation */
		if (e.cancelled || e.propogationStopped) {
			return ;
		}

		var finalTarget:Null<Entity> = getEntityAtPoint( e.position );
		if (finalTarget != null && !(finalTarget.isHidden() || finalTarget.isCached() || finalTarget.destroyed)) {
			var eventPath:Array<Entity> = new Array();
			var currentTarget:Entity = finalTarget;
			eventPath.unshift( currentTarget );

			while (currentTarget.parent != null) {
				currentTarget = currentTarget.parent;
				eventPath.unshift( currentTarget );
			}

			// traverse the event-path
			for (target in eventPath) {
				// dispatch the event on the current target
				target.dispatch(e.type, e);

				/* if the event has been cancelled, or has ceased propogation */
				if (e.cancelled || e.propogationStopped) {
					// stop traversal
					break;
				}
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

	/* the cursor for [this] Stage */
	public var cursor(get, set):String;
	private function get_cursor():String {
		return canvas.canvas.style.cursor;
	}
	private function set_cursor(v : String):String {
		return (canvas.canvas.style.cursor = v);
	}

	/* the Draing Context for [this] Stage */
	public var ctx(get, never):Ctx;
	private inline function get_ctx():Ctx return canvas.context;

/* === Instance Fields === */

	public var canvas : Canvas;
	public var children : Array<Entity>;
	public var registry : Map<String, Entity>;
	public var noclear : Bool = false;

	private var manager : FrameManager;
	private var mouseManager : MouseListener;
	private var keyManager : KeyListener;
	private var mouseWatcher : MouseWatcher;
	private var styles : GlobalStyles;

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
