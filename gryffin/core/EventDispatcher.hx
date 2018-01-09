package gryffin.core;

import tannus.io.Signal;
import tannus.ds.Obj;
import haxe.rtti.Meta;
import tannus.io.RegEx;

import gryffin.Tools.*;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class EventDispatcher {
	/* Constructor Function */
	public function new():Void {
		__sigs = new Map();
		__metaBind();
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
		sig( name ).on( handler );
	}

	/**
	  * Listen for an Event only once
	  */
	public function once<T>(name:String, handler:T->Void):Void {
		sig( name ).once( handler );
	}

	/**
	  * Listen for an Event, conditionally
	  */
	public function when<T>(name:String, test:T->Bool, handler:T->Void):Void {
		sig(name).when(test, handler);
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

	/**
	  * Forward [event] to [target]
	  */
	public function forward<A,B>(event:String, target:EventDispatcher, ?mapper:A->B):Void {
		on(event, function(data : A) {
			target.call(event, (mapper != null ? untyped mapper( data ) : untyped data));
		});
	}

	/**
	  * Forward all [events] to [target]
	  */
	public function forwardAll<A,B>(events:Array<String>, target:EventDispatcher, ?mapper:A->B):Void {
		function _handler(name:String, data:A):Void {
			target.call(name, (mapper != null ? untyped mapper( data ) : untyped data));
		}
		for (event in events) {
			on(event, _handler.bind(event));
		}
	}

	/**
	  * Bind events based on meta-data
	  */
	private function __metaBind():Void {
		var klass:Class<EventDispatcher> = Type.getClass( this );
		var meta:Obj = Meta.getFields( klass );
		var self:Obj = this;
		for (key in meta.keys()) {
			var metas:Obj = Obj.fromDynamic( meta[key] );
			if (metas.exists('on')) {
				var args:Array<String> = metas['on'];
				var handler:Dynamic->Void = self[key];
				handler = cast Reflect.makeVarArgs(Reflect.callMethod.bind(this, handler, _));
				for (name in args) {
					__mbind(name, handler);
				}
			}
		}
	}

	/**
	  * do fancy meta-binding
	  */
	private function __mbind(key:String, handler:Dynamic->Void):Void {
		var forwardPattern:RegEx = ~/\[([A-Z0-9_]+)\]->(.+)/gi;
		if (key.has(',')) {
			var keys = key.split(',').macmap(_.trim());
			for (k in keys) {
				__mbind(k, handler);
			}
		}
		else {
			if (forwardPattern.match( key )) {
				var data = forwardPattern.extract( key );
				var self:Obj = this;
				defer(function() {
					var field:EventDispatcher = self[data[1]];
					field.__mbind(data[2], handler);
				});
			}
			else {
				on(key, handler);
			}
		}
	}

/* === Instance Fields === */

	private var __sigs : Map<String, Signal<Dynamic>>;
}
