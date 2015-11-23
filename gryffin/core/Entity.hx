package gryffin.core;

import tannus.geom.Point;
import tannus.internal.TypeTools.typename;
import tannus.io.Ptr;
import tannus.ds.Object;

import gryffin.display.Ctx;
import gryffin.core.Stage;
import gryffin.core.EventDispatcher;

import gryffin.fx.*;

class Entity extends EventDispatcher {
	/* Constructor Function */
	public function new():Void {
		super();

		_cached = false;
		_hidden = false;
		destroyed = false;
		parent = null;
		priority = 0;
		effects = new Array();

		once('activated', init);
	}

/* === Instance Methods === */

	/**
	  * Mark [this] Entity for deletion
	  */
	public function delete():Void {
		destroyed = true;
	}

	/**
	  * Mark [this] Entity as 'hidden'
	  */
	public function hide():Void {
		_hidden = true;
	}

	/**
	  * Mark [this] Entity as 'not hidden'
	  */
	public function show():Void {
		_hidden = false;
	}

	/**
	  * Mark [this] Entity as 'cached'
	  */
	public function cache():Void {
		_cached = true;
	}

	/**
	  * Mark [this] Entity as 'not cached'
	  */
	public function uncache():Void {
		_cached = false;
	}

	/**
	  * Toggle [this] Entity's "cached" state
	  */
	public function toggleCache():Void {
		(_cached?uncache:cache)();
	}

	/**
	  * Toggle [this] Entity's "hidden" state
	  */
	public function toggleHidden():Void {
		(_hidden?show:hide)();
	}

	/**
	  * Initialize [this] Entity
	  */
	public function init(s : Stage):Void {
		trace(typename(this) + ' has been initialized');
	}

	/**
	  * Update the state of [this] Entity
	  */
	public function update(s : Stage):Void {
		for (e in effects) {
			if (e.active( this )) {
				e.affect( this );
			}
		}
	}

	/**
	  * Render [this] Entity
	  */
	public function render(s:Stage, c:Ctx):Void {
		null;
	}

	/**
	  * Add [sibling] as a child of [this]'s parent
	  */
	public function addSibling(sibling : Entity):Void {
		if (stage == null) {
			on('activated', function(s) {
				addSibling( sibling );
			});
		}
		else {
			if (parent != null) {
				parent.addChild( sibling );
			}
			else {
				stage.addChild( sibling );
			}
		}
	}

	/**
	  * Check whether [this] Entity 'contains' the given Point
	  */
	public function containsPoint(p : Point):Bool {
		return false;
	}

	/**
	  * Add an Effect to [this] Entity
	  */
	public function addEffect(e : Effect<Dynamic>):Void {
		effects.push( e );
	}

	/**
	  * Remove an Effect from [this] Entity
	  */
	public function removeEffect(e : Effect<Dynamic>):Void {
		effects.remove( e );
	}

/* === Instance Fields === */

	public var _cached : Bool;
	public var _hidden : Bool;
	public var effects : Array<Effect<Dynamic>>;
	
	public var destroyed : Bool;
	public var priority : Int;
	public var stage : Stage;
	public var parent : Null<EntityContainer>;
}
