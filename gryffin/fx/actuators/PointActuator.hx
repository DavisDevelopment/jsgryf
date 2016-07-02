package gryffin.fx.actuators;

import tannus.geom.*;
import tannus.math.Percent;

class PointActuator extends Actuator {
	/* Constructor Function */
	public function new(x:Point, y:Point):Void {
		super();

		cursor = x;
		origin = cursor.clone();
		goal = y;
	}

/* === Instance Methods === */

	override public function update(progress : Percent):Void {
		cursor.copyFrom(origin.lerp(goal, progress.of( 1.0 )));
	}

	override public function reverse():Actuator {
		return new PointActuator(cursor, origin);
	}

/* === Instance Fields === */

	private var origin : Point;
	private var goal : Point;
	private var cursor : Point;
}
