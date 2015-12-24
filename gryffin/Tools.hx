package gryffin;

import tannus.html.Win;
import tannus.html.Element;
import tannus.math.Random;
import tannus.io.Byte;

import tannus.io.Signal;
import tannus.io.EventDispatcher;

import js.html.ImageElement in Img;

using Lambda;
using StringTools;
using tannus.ds.StringUtils;
using tannus.ds.ArrayTools;

/**
  * Utility class of 'global' Functions
  */
class Tools {
	/**
	  * Wait [ms] milliseconds, then invoke [action]
	  */
	public static inline function wait(ms:Int, action:Void->Void):Void {
		win.setTimeout(action, ms);
	}

	/**
	  * Delay the invokation of the given Function till the end of the current Stack
	  */
	public static function defer(f : Void->Void):Void {
		wait(5, f);
	}

	/**
	  * Obtain a unique identifier
	  */
	public static function makeUniqueIdentifier(digits : Int):String {
		var id:String = '';
		var r:Random = new Random();

		/* generate [digits] random characters */
		for (i in 0...digits) {
			// the numerical range to generate the Byte from
			var range:Array<Int> = [0, 0];

			// randomly decide whether to generate a letter, or a number
			var letter:Bool = r.randbool();

			// if letter was chosen
			if ( letter ) {
				// randomly decide between upper and lower cases
				var upper:Bool = r.randbool();
				
				range = (upper ? [65, 90] : [97, 122]);
			}

			// if number was chosen
			else {
				range = [48, 57];
			}

			var c:Byte = new Byte(r.randint(range[0], range[1]));
			id += c.aschar;
		}

		/* if the generated id has already been generated */
		if (used_idents.has( id )) {
			return makeUniqueIdentifier( digits );
		}

		/* otherwise */
		else {
			used_idents.push( id );
			return id;
		}
	}

	/**
	  * De-allocate a unique identifier
	  */
	public static function deleteUniqueIdentifier(id : String):Bool {
		return used_idents.remove( id );
	}

/* === Static Fields === */

	/* the current Date, as a Float */
	public static var now(get, never):Float;
	private static inline function get_now():Float {
		return (Date.now().getTime());
	}

	/* The current Window Object */
	private static var win(get, never):Win;
	private static inline function get_win():Win {
		return Win.current;
	}

	/* the collection of used identifiers */
	private static var used_idents : Array<String> = {new Array();};
}
