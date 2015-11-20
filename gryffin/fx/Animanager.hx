package gryffin.fx;

import gryffin.fx.Effect;
import gryffin.fx.Animation;
import gryffin.core.Entity;

using Lambda;
using tannus.ds.ArrayTools;

class Animanager<T:Entity> extends Effect<T> {
	/* Constructor Function */
	public function new():Void {
		super();

		animations = new Array();
	}

/* === Instance Methods === */

	/**
	  * Add and start an Animation
	  */
	public function addAnimation(a : Animation):Void {
		animations.push( a );
		a.start();
	}

	/**
	  * Whether to run in the current frame
	  */
	override public function active(e : T):Bool {
		return true;
	}

	/**
	  * Manage the animations
	  */
	override public function affect(e : T):Void {
		super.affect( e );
		
		/* == update all Animation objects == */
		for (a in animations) {
			a.update();
		}

		/* == remove the Animations that have completed == */
		animations = animations.macfilter( !_.complete );
	}

/* === Instance Fields === */

	public var animations : Array<Animation>;
}
