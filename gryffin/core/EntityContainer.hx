package gryffin.core;

import gryffin.display.Ctx;
import gryffin.core.Entity;

import tannus.nore.Selector;
import tannus.io.Getter;

using Lambda;
using tannus.ds.ArrayTools;

class EntityContainer extends Entity {
	/* Constructor Function */
	public function new():Void {
		super();

		children = new Array();
	}

/* === Instance Methods === */

	/**
	  * Add an Entity to [this] Container
	  */
	public function addChild(e : Entity):Void {
		if (!children.has( e )) {
			children.push( e );
			e.parent = this;
			if (stage != null) {
				stage.registry[e.id] = e;
				e.stage = stage;
				e.dispatch('activated', stage);
			}
			else {
				on('activated', function(s : Stage) {
					s.registry[e.id] = e;
					e.stage = s;
					e.dispatch('activated', s);
				});
			}
		}
	}

	/**
	  * Query [this] Container
	  */
	public function get<T:Entity>(selector : String):Selection<T> {
		return new Selection(selector, untyped Getter.create( children ));
	}

	/**
	  * Update [this] Container
	  */
	override public function update(s : Stage):Void {
		super.update( s );

		/* remove those Entities which have been marked for deletion */
		var filt = children.splitfilter(function(e) return !e.destroyed);
		for (e in filt.fail) {
			stage.registry.remove( e.id );
		}
		children = filt.pass;

		/* sort the Entities by priority */
		haxe.ds.ArraySort.sort(children, function(a:Entity, b:Entity) {
			return (a.priority - b.priority);
		});

		/* update [children] */
		for (e in children) {
			if ( !e._cached )
				e.update( s );
		}
	}

	/**
	  * Render [this] Container
	  */
	override public function render(s:Stage, c:Ctx):Void {
		super.render(s, c);

		for (e in children) {
			if ( !e._hidden )
				e.render(s, c);
		}
	}

/* === Instance Fields === */

	public var children : Array<Entity>;
}
