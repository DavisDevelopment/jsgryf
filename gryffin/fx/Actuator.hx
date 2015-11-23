package gryffin.fx;

import tannus.math.Percent;

class Actuator {
	/* Constructor Function */
	public function new():Void {

	}

/* === Instance Methods === */

	/**
	  * Method which handles each step of the Animation in question
	  */
	public function update(progress : Percent):Void {
		trace('animation is $progress complete');
	}

	/**
	  * Get an actuator which is the reversal of [this]
	  */
	public function reverse():Actuator {
		return new Actuator();
	}
}
