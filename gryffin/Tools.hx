package gryffin;

import tannus.html.Win;
import tannus.html.Element;

import tannus.io.Signal;
import tannus.io.EventDispatcher;

import js.html.ImageElement in Img;

/**
  * Utility class of 'global' Functions
  */
class Tools {
	/**
	  * Delay the invokation of the given Function till the end of the current Stack
	  */
	public static inline function defer(f : Void->Void):Void {
		win.setTimeout(f, 5);
	}

	/* The current Window Object */
	private static var win(get, never):Win;
	private static inline function get_win():Win {
		return Win.current;
	}
}
