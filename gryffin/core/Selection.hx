package gryffin.core;

import gryffin.core.*;

import tannus.io.Getter;
import tannus.nore.Selector;
import tannus.ds.Obj;
import tannus.geom2.*;

using Lambda;
using tannus.ds.ArrayTools;

class Selection<T:Entity> {
	/* Constructor Function */
	public function new(sel:Selector, entities:Getter<Array<T>>):Void {
		selector = sel;
		all = entities;

		update();
	}

/* === Instance Methods === */

	/**
	  * update the current selection
	  */
	public function update():Void {
		selected = cast selector.filter(all.get());
	}

	/**
	  * get the entity at the given index
	  */
	public function at(index : Int):Null<T> {
		return selected[index];
	}

	/**
	  * Iterate over all Entities in [this] selection
	  */
	public function iterator():Iterator<T> {
		return selected.iterator();
	}

	/**
	  * Get a sub-selection of [this] one
	  */
	public function filter<O:T>(sel : Selector):Selection<O> {
		return new Selection(sel, untyped Getter.create(selected));
	}

	/**
	  * stuff
	  */
	public function containsPoint(p : Point<Float>):Selection<T> {
		var gettr:Getter<Array<T>> = Getter.create(all.macfilter(_.containsPoint(p)));
		return new Selection(selector, gettr);
	}

	/**
	  * Invoke the given method with the given arguments on every selected Entity
	  */
	public function call(method:String, ?args:Array<Dynamic>):Void {
		if (args == null)
			args = new Array();
		for (ent in selected) {
			var e:Obj = ent;
			var f = e[method];
			f = Reflect.callMethod.bind(ent, f, _);

			try {
				f( args );
			}
			catch(error : Dynamic) {
				throw error;
			}
		}
	}

	/**
	  * cache all selected items
	  */
	public function cache():Void {
		selected.each(_.cache());
	}

	/**
	  * uncache all selected items
	  */
	public function uncache():Void {
		selected.each(_.uncache());
	}

	/* hide all */
	public function hide():Void selected.each(_.hide());

	/* show all */
	public function show():Void selected.each(_.show());

	/* deleted all */
	public function delete():Void selected.each(_.delete());

	/**
	  * obtain a Selection consisting of the children of [this] Selection
	  */
	public function children():Selection<Entity> {
		return new Selection('!String', _selectedChildren.bind());
	}

	/**
	  * get an array of all children
	  */
	private function _selectedChildren():Array<Entity> {
		var results = new Array();
		for (e in selected) {
			if (Std.is(e, EntityContainer)) {
				results = results.concat(cast(e, EntityContainer).getChildren());
			}
		}
		return results;
	}

/* === Computed Instance Fields === */

	/* the number of selected items */
	public var length(get, never):Int;
	private inline function get_length():Int return selected.length;

/* === Instance Fields === */

	public var selector : Selector;
	public var selected : Array<T>;
	public var all : Getter<Array<T>>;
}
