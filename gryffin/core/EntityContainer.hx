package gryffin.core;

import gryffin.display.Ctx;
import gryffin.core.Entity;

import tannus.nore.Selector;
import tannus.io.Getter;
import tannus.geom.*;

using Lambda;
using tannus.ds.ArrayTools;

class EntityContainer extends Entity implements Container {
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
	  * check whether [child] is a child of [this]
	  */
	public function hasChild(child : Entity):Bool {
		return getChildren().has( child );
	}

	/**
	  * report [this]'s list of children
	  * default behavior is to just return [children], but sub-classes can 
	  * override this
	  */
	public function getChildren():Array<Entity> {
		return children.filter( isValidChild );
	}

	/**
	  * Query [this] Container
	  */
	public function get<T:Entity>(selector : String):Selection<T> {
		return new Selection(selector, untyped getChildren);
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
		for (e in getChildren()) {
			if (!e._cached && shouldChildUpdate( e )) {
				e.update( s );
			}
		}
	}

	/**
	  * Render [this] Container
	  */
	override public function render(s:Stage, c:Ctx):Void {
		super.render(s, c);

		for (e in getChildren()) {
			if (!e._hidden && shouldChildRender( e )) {
				e.render(s, c);
			}
		}
	}

	/**
	  * get an Array of children of [this] which 'contain' [p]
	  */
	public function getEntitiesAtPoint(p : Point):Array<Entity> {
		var res:Array<Entity> = new Array();
		for (e in getChildren()) {
			if (e.containsPoint( p )) {
				res.push( e );
				if (Std.is(e, EntityContainer)) {
					var c:EntityContainer = cast e;
					res = res.concat(c.getEntitiesAtPoint( p ));
				}
			}
		}
		return res;
	}

	/**
	  * get the priority Entity at the given Point
	  */
	public function getEntityAtPoint(p : Point):Null<Entity> {
		var target:Null<Entity> = null;
		var targets = getChildren().copy();
		targets.reverse();
		for (e in targets) {
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
		return target;
	}
	public function getEntityAt(x:Float, y:Float):Null<Entity> {
		return getEntityAtPoint(new Point(x, y));
	}

	/**
	  * additional filter(s) to apply to the children of [this] Entity
	  */
	public function isValidChild(child : Entity):Bool {
		return true;
	}

	/**
	  * additional filtering for updating children
	  */
	public function shouldChildUpdate(child : Entity):Bool {
		return true;
	}

	/**
	  * additional filtering for rendering children
	  */
	public function shouldChildRender(child : Entity):Bool {
		return true;
	}

/* === Instance Fields === */

	public var children : Array<Entity>;
}
