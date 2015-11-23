package gryffin.fx;

import gryffin.fx.Animation;

using tannus.ds.ArrayTools;

class Animations {
/* === Static Methods === */

	/**
	  * Add [anim] to the registry
	  */
	public static function link(anim : Animation):Void {
		registry.push( anim );
	}

	/**
	  * Update all Animations, and delete those which have completed
	  */
	@:allow( gryffin.core.Stage )
	private static function tick():Void {
		for (anim in registry) {
			anim.update();
		}
		registry = registry.macfilter(!_.complete);
	}

	/**
	  * Make [stage] the manager of the update-cycle, if we don't yet have one
	  */
	@:allow( gryffin.core.Stage )
	private static function claim(stage : gryffin.core.Stage):Void {
		if ( manager == null )
			manager = stage;
	}
	
/* === Static Fields === */

	/* all currently active Animations */
	private static var registry : Array<Animation> = {new Array();};

	/* the Stage which has assumed controls over the update-cycle */
	@:allow( gryffin.core.Stage )
	private static var manager : Null<gryffin.core.Stage> = {null;};
}
