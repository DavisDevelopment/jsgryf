package gryffin.core;

import gryffin.core.*;

import tannus.io.Getter;
import tannus.nore.Selector;
import tannus.ds.Obj;

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
	  * Invoke the given method with the given arguments on every selected Entity
	  */
	public function call(method:String, ?args:Array<Dynamic>):Void {
		if (args == null)
			args = new Array();
		for (ent in selected) {
			var e:Obj = ent;
			trace(e.get( method ));
			if (e.exists(method) && Reflect.isFunction(e[method])) {
				Reflect.callMethod(ent, e[method], args);
			}
			else {
				throw 'TypeError: \'$method\' is not a valid method of $ent';
			}
		}
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
