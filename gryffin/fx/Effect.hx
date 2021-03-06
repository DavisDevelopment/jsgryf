package gryffin.fx;

import gryffin.core.Entity;

class Effect<T : Entity> {
	/* Constructor Function */
	public function new():Void {

	}

/* === Instance Methods === */

	/**
	  * Determine whether to affect the given Entity
	  */
	public function active(e : T):Bool {
		return true;
	}

	/**
	  * Do stuff to the Entity
	  */
	public function affect(e : T):Void {
		null;
	}

	/**
	  * Perform any needed initializations when [this] Effect is attached to the Entity
	  */
	public function attach(e : T):Void {
		null;
	}
}
