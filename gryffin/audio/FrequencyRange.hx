package gryffin.audio;

import tannus.io.Char;
import tannus.ds.IComparable;

import tannus.math.TMath.*;
import tannus.ds.SortingTools.compresolve as compchain;

import haxe.extern.EitherType as Either;

using StringTools;
using tannus.ds.StringUtils;
using tannus.ds.ArrayTools;
using tannus.math.TMath;
using tannus.FunctionTools;

class FrequencyRange implements IComparable<FrequencyRange> {
    /* Constructor Function */
    public function new(min:Int, max:Int):Void {
        this.min = min;
        this.max = max;

        untyped {
            __js__('Object.freeze({0})', this);
        }
    }

/* === Instance Methods === */

    /**
      check if [n] is inside [this] range
     **/
    public inline function contains(n: Float):Bool {
        return n.inRange(min, max);
    }

    /**
      check whether [x] is a subset of [this]
     **/
    public inline function containsRange(x: FrequencyRange):Bool {
        return (contains(x.min) && contains(x.max));
    }

    /**
      check if [this] FrequencyRange overlaps with [x]
     **/
    public inline function overlaps(x: FrequencyRange):Bool {
        return (min <= x.max && x.min <= max);
    }

    /**
      get the size of [this] Frequency range
     **/
    public inline function size():Int {
        return (max - min);
    }

    /**
      compare [this] range to [x]
     **/
    public function compareTo(x: FrequencyRange):Int {
        return
            if (this == x) 0;
            else if (min < x.min) -1;
            else if (min > x.min) {
                if (max <= x.max) -1;
                else 1;
            }
            else if (min == x.min) {
                if (max > x.max) 1;
                else if (max < x.max) -1;
                else 0;
            }
            else 0;
        //if (this == x) return 0;
        //inline function c(x,y):Int return Reflect.compare(x, y).clamp(-1, 1);

        //return compchain([c(min, x.min), c(max, x.max)]);
        /*
        var comps = [c(min, x.min), c(max, x.max), c(size(), x.size())];
        switch comps {
            case [0, 0, 0]:
                return 0;
            case [-1, 0, _]:
                return -1;
        }
        */
    }

/* === Instance Fields === */

    public var min(default, null): Int;
    public var max(default, null): Int;
}
