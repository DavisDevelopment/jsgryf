package gryffin.core;

import gryffin.Tools.now;

class Component {
	public function new():Void {}
/* === Instance Fields === */

	// the next Component, for iteration
	@:allow( gryffin )
	public var next(default, null):Null<Component> = null;
	
	// the Entity to which [this] is attached
	@:allow( gryffin )
	public var owner(default, null):Null<Entity> = null;

	// overridden by subclasses
	public var name(get, null):String;
	private function get_name():String {
		return Type.getClassName(Type.getClass( this ));
	}

/* === Instance Methods === */

	public function onAdded():Void {
		return ;
	}
	public function onRemoved():Void {
		return ;
	}
	public function onUpdate(time : Float):Void {
		if (next != null) {
			next.onUpdate( time );
		}
	}
}
