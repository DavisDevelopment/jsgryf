package gryffin.fx;

import gryffin.core.Entity;
import gryffin.fx.Effect;

class TimedEffect<T:Entity> extends Effect<T> {
	/* Constructor Function */
	public function new():Void {
		super();

		lifetime = -1;
		interval = 1000;
		last_affect = null;
		created_on = now();
	}

/* === Instance Methods === */

	override public function active(e : T):Bool {
		return (last_affect == null || (now() - last_affect) >= interval);
	}

	override public function affect(e : T):Void {
		last_affect = now();
		if (lifetime > -1 && (now() - created_on) > lifetime) {
			e.removeEffect( this );
		}
	}

	private inline function now():Float {
		return (Date.now().getTime());
	}

/* === Instance Fields === */

	/* number of milliseconds to wait between actions */
	public var interval : Int;

	/* number of milliseconds before removal */
	public var lifetime : Int;

	/* time of last action */
	private var last_affect : Null<Float>;

	/* time of creation */
	private var created_on : Float;
}
