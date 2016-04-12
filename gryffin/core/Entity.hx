package gryffin.core;
import tannus.geom.*;
import tannus.internal.TypeTools.typename;
import tannus.io.Ptr;
import tannus.ds.Object;
import tannus.nore.Selector;

import gryffin.display.Ctx;
import gryffin.core.Stage;
import gryffin.core.EventDispatcher; import gryffin.fx.*;
import gryffin.Tools;

using Lambda;

class Entity extends EventDispatcher {
	/* Constructor Function */
	public function new():Void {
		super();

		id = Tools.makeUniqueIdentifier( 8 );
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
		Tools.deleteUniqueIdentifier( id );
	}

	/**
	  * un-delete [this] Entity
	  */
	@:access(gryffin.Tools)
	public function restore():Void {
		destroyed = false;
		stage.addChild( this );
		Tools.used_idents.push( id );
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
	  * Check whether [this] Entity is 'hidden'
	  */
	public function isHidden():Bool {
		return _hidden;
	}

	/**
	  * Check whether [this] Entity is 'cached'
	  */
	public function isCached():Bool {
		return _cached;
	}

	/**
	  * Initialize [this] Entity
	  */
	public function init(s : Stage):Void {
		calculateGeometry( s.rect );
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
	  * Calculate [this] Entity's geometry based on the given Rectangle (usually used to represent the viewport rect)
	  */
	public function calculateGeometry(r : Rectangle):Void {
		null;
	}

	/**
	  * Perform ORegEx validation on [this] Entity
	  */
	public function is(selector : String):Bool {
		var sel:Selector = new Selector( selector );
		return sel.test( this );
	}

	/**
	  * Add an Effect to [this] Entity
	  */
	public function addEffect(e : Effect<Dynamic>):Void {
		if (!effects.has( e )) {
			e.attach( this );
			effects.push( e );
		}
	}

	/**
	  * Remove an Effect from [this] Entity
	  */
	public function removeEffect(e : Effect<Dynamic>):Void {
		effects.remove( e );
	}

	/* get the child-Entities of [this] One */
	public function getChildren():Array<Entity> {
		return new Array();
	}

	/**
	  * get the nearest [parent] for whom [test] returns `true`
	  */
	public function parentUntil<T : EntityContainer>(test : EntityContainer -> Bool):Null<T> {
		if (parent == null) {
			return null;
		}
		else {
			if (test( parent )) {
				return untyped parent;
			}
			else {
				return parent.parentUntil( test );
			}
		}
	}

/* === Instance Fields === */

	public var _cached : Bool;
	public var _hidden : Bool;
	public var effects : Array<Effect<Dynamic>>;
	
	public var destroyed : Bool;
	public var priority : Int;
	public var stage : Stage;
	public var parent(default, set): Null<EntityContainer>;
	private function set_parent(p : Null<EntityContainer>):Null<EntityContainer> {
		if (p != null && !Std.is(p, EntityContainer))
			throw 'Not a container!';
		return (parent = p);
	}
	public var id : String;
}
