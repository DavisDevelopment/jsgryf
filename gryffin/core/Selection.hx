package gryffin.core;

import gryffin.core.*;

import tannus.io.Getter;
import tannus.nore.Selector;

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

/* === Computed Instance Fields === */

	/* the number of selected items */
	public var length(get, never):Int;
	private inline function get_length():Int return selected.length;

/* === Instance Fields === */

	public var selector : Selector;
	public var selected : Array<T>;
	public var all : Getter<Array<T>>;
}
