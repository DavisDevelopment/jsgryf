package gryffin.fx;

import gryffin.fx.Actuator;

import tannus.io.Ptr;
import tannus.math.TMath.lerp;
import tannus.math.Percent;

class NumberActuator extends Actuator {
	/* Constructor Function */
	public function new(fromm:Ptr<Float>, too:Float):Void {
		super();

		current = fromm;
		start = fromm.get();
		goal = too;
	}

	override public function update(p : Percent):Void {
		current.set(lerp(current.get(), goal, p.delta));
	}

	override public function reverse():Actuator {
		return cast new NumberActuator(current, start);
	}

	private var current:Ptr<Float>;
	private var start:Float;
	private var goal:Float;
}
