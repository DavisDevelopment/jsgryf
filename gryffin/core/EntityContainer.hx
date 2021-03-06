package gryffin.core;

import gryffin.display.Ctx;
import gryffin.core.Entity;

import tannus.nore.Selector;
import tannus.io.Getter;
import tannus.geom2.*;

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
				calculateGeometry(stage.rect.float());
				e.dispatch('activated', stage);
			}
			else {
				on('activated', function(s : Stage) {
					s.registry[e.id] = e;
					e.stage = s;
					calculateGeometry(s.rect.float());
					e.dispatch('activated', s);
				});
			}
		}
	}

	public function removeChild(e: Entity):Bool {
	    if (hasChild( e )) {
	        children.remove( e );
	        if (stage != null)
                stage.eraseChild( e );
            return true;
	    }
        else return false;
	}

	/**
	  * 'claim' [child] as a child-entity of [this]
	  */
	public function claimChild(child: Entity):Void {
	    if (!hasChild( child )) {
	        child.parent = this;
	        if (stage != null) {
	            stage.registry[child.id] = child;
	            child.stage = stage;
	            child.dispatch('activated', stage);
	        }
            else {
                on('activated', function(s: Stage) {
                    s.registry[child.id] = child;
                    child.stage = s;
                    child.dispatch('activated', s);
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
	override public function getChildren():Array<Entity> {
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
	@:access( gryffin.core.Stage )
	override public function update(s : Stage):Void {
		super.update( s );

		/* remove those Entities which have been marked for deletion */
		var dels = children.filterInPlace(c -> c.destroyed);
		for (e in dels) {
			stage.registry.remove( e.id );
		}

		/* sort the Entities by priority */
		children.isort( Stage.child_sorter );
		//haxe.ds.ArraySort.sort(children, function(a:Entity, b:Entity) {
			//return (a.priority - b.priority);
		//});

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
	  * calculate [this] Entity's geometry
	  */
	override public function calculateGeometry(rect : Rect<Float>):Void {
		super.calculateGeometry( rect );

		for (e in getChildren()) {
			e.calculateGeometry( rect );
		}
	}

	/**
	  * get an Array of children of [this] which 'contain' [p]
	  */
	public function getEntitiesAtPoint(p : Point<Float>):Array<Entity> {
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
	public function getEntityAtPoint(p : Point<Float>):Null<Entity> {
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
