package gryffin.fx;

import tannus.math.Percent;

import Math.*;

class Easing {
	/**
	  * Exponential (must be bound)
	  */
	public static function exponential(delta:Float, n:Int):Float {
		return pow(delta, n);
	}

	/* Square */
	public static function square(delta : Float):Float {
		return pow(delta, 2);
	}

	/* Circle */
	public static function circ(delta : Float):Float {
		return (1 - sin(acos(delta)));
	}

	/* Bow (must be bound) */
	public static function bow(delta:Float, x:Float):Float {
		return (pow(delta, 2) * ((x + 1) * delta - x));
	}

	/* Bounce */
	public static function bounce(delta : Float):Float {
		var a:Float = 0;
		var b:Float = 1;

		while ( true ) {
			if (delta >= ((7 - 4 * a) / 11)) {
				return (-pow((11 - 6 * a - 11 * delta)/4, 2) + pow(b, 2));
			}

			a += b;
			b /= 2;
		}
	}

	/* Elastic (must be bound) */
	public static function elastic(progress:Float, x:Float):Float {
		return Math.pow(2, 10 * (progress-1)) * Math.cos(20*Math.PI*x/3*progress);
	}

	/**
	  * Effectively reverses the given delta function
	  */
	public static function makeEaseOut(f : Float -> Float):Float -> Float {
		return function(d : Float):Float {
			return (1 - f(1 - d));
		};
	}

	/**
	  * Effectively mirrors the given delta function
	  */
	public static function makeEaseInOut(f:Float->Float):Float->Float {
		return function(d : Float):Float {
			if ( d < 0.5 ) {
				return (f(2 * d) / 2);
			}
			else {
				return ((2 - f(2 * (1 - d))) / 2);
			}
		};
	}
}
