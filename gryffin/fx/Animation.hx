package gryffin.fx;

import gryffin.core.Entity;
import gryffin.fx.Effect;
import gryffin.fx.Actuator;
import gryffin.fx.Animations;

import tannus.math.Percent;
import tannus.io.VoidSignal;

class Animation {
	/* Constructor Function */
	public function new():Void {
		start_time = null;
		complete = false;
		oncomplete = new VoidSignal();
		actuators = new Array();
	}

/* === Instance Methods === */

	/**
	  * Start [this] Animation
	  */
	public function start():Void {
		start_time = now;
		Animations.link( this );
	}

	/**
	  * Update the state of [this] Animation
	  */
	public function update():Void {
		if ( !complete ) {
			var progress:Float = (passed / duration);
			if (progress > 1) {
				progress = 1;
			}

			var delt:Float = delta( progress );
			step(delt * 100);

			if (progress == 1) {
				complete = true;
				oncomplete.fire();
			}
		}
	}

	/**
	  * Calculate delta
	  ------------------
	  * default: linear
	  */
	public dynamic function delta(progress : Float):Float {
		return progress;
	}

	/**
	  * Handle Animation step
	  */
	public function step(d : Percent):Void {
		for (a in actuators) {
			a.update( d );
		}
	}

	/**
	  * Add an Actuator to [this] Animation
	  */
	public function actuate(a : Actuator):Void {
		actuators.push( a );
	}

	/**
	  * Get an Animation that is the reversal of [this] one
	  */
	public function reverse():Animation {
		var rev = new Animation();
		rev.duration = duration;
		rev.delta = delta;
		
		for (a in actuators) {
			rev.actuate(a.reverse());
		}
		
		return rev;
	}

/* === Computed Instance Fields === */

	/* the current time */
	private var now(get, never):Float;
	private inline function get_now():Float return (Date.now().getTime());

	/* the amount of time which has passed since [this] Animation started */
	private var passed(get, never):Float;
	private inline function get_passed():Float {
		return (if (start_time != null) (now - start_time) else null);
	}

/* === Instance Fields === */

	/* the full time [this] Animation should take */
	public var duration : Float;

	/* the time at which the Animation started */
	private var start_time : Float;

	/* whether [this] Animation has completed yet */
	public var complete : Bool;

	/* a Signal which fires when [this] Animation completes */
	public var oncomplete : VoidSignal;

	/* the Actuators in use by [this] Animation */
	public var actuators : Array<Actuator>;
}
