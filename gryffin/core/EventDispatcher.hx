package gryffin.core;

import tannus.io.Signal;

class EventDispatcher {
	/* Constructor Function */
	public function new():Void {
		__sigs = new Map();
	}

/* === Instance Methods === */

	/**
	  * Get a named Signal
	  */
	private function sig<T>(name : String):Signal<T> {
		if (!__sigs.exists(name))
			__sigs.set(name, new Signal());
		return (untyped __sigs.get(name));
	}

	/**
	  * Listen for an Event of the given type
	  */
	public function on<T>(name:String, handler:T->Void):Void {
		sig(name).on( handler );
	}

	/**
	  * Listen for an Event only once
	  */
	public function once<T>(name:String, handler:T->Void):Void {
		sig(name).once(handler);
	}

	/**
	  * Listen for an Event, conditionally
	  */
	public function when<T>(name:String, test:T->Bool, handler:T->Void):Void {
		sig(name).when(test, handler);
	}

	/**
	  * Listen for an Event, [n] times
	  */
	public function times<T>(name:String, count:Int, handler:T->Void):Void {
		sig(name).times(count, handler);
	}

	/**
	  * Listen for an Event, every [interval] times it fires
	  */
	public function every<T>(name:String, interval:Int, handler:T->Void):Void {
		sig(name).every(interval, handler);
	}

	/**
	  * Stop listening for an Event
	  */
	public function off(name:String, ?handler:Dynamic->Void):Void {
		var s = sig(name);
		if (handler != null)
			s.off( handler );
		else
			s.clear();
	}

	/**
	  * Alias to 'off'
	  */
	public function ignore(name:String, ?handler:Dynamic->Void):Void {
		off(name, handler);
	}

	/**
	  * Dispatch an Event
	  */
	public function dispatch<T>(name:String, data:T):Void {
		sig(name).call( data );
	}

	/**
	  * Alias to 'dispatch'
	  */
	public inline function call<T>(name:String, data:T):Void {
		dispatch(name, data);
	}

/* === Instance Fields === */

	private var __sigs : Map<String, Signal<Dynamic>>;
}
