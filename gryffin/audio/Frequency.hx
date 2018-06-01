package gryffin.audio;

import tannus.io.Char;

import tannus.math.TMath.*;

import haxe.extern.EitherType as Either;

using StringTools;
using tannus.ds.StringUtils;
using tannus.ds.ArrayTools;
using tannus.math.TMath;
using tannus.FunctionTools;


/**
  purpose of class
 **/
class FrequencyType {
    /* Constructor Function */
    public function new(value:FreqVal, ?unit:FreqUnit):Void {
        this.unit = Hertz;
        this.time = null;
        this.val = value;

        if ((value is FrequencyType)) {
            _pullFrequency(cast value);
        }
    }

/* === Instance Methods === */

    inline function _pullFrequency(v: FrequencyType) {
        this.time = v.time;
        this.val = v.val;
        this.unit = v.unit;
    }

    function _pullFloat(v: Float) {
        this.val = v;
    }

    function _pullString(v: String) {
        var regexp = ~/^(\d+(?:\.\d+)?)\b?(\w+)?$/i;
        v = v.trim();
        if (regexp.match( v )) {
            this.val = Std.parseFloat(regexp.matched(1));
            var units: String = 'default';

            try {
                units = regexp.matched(2);
            }
            catch (e : Dynamic) {
                null;
            }

            switch units {
                case 'default':
                    if (unit == null) {
                        unit = Hertz;
                    }

                case 'hz':
                    unit = Hertz;

                case 'khz':
                    unit = Kilohertz;

            }
        }
    }

    function _pullAnon(o: Dynamic) {
        //
    }

    function _calcTime() {
        //
    }

    static function stou(s: String):FrequencyUnit {
        return (switch (s.trim().toLowerCase()) {
            case 'hz': Hertz;
            case 'khz': Kilohertz;
            case 'midi': Midi;
            case 'samples': Samples;
            case 's','sec': Seconds;
            case 'ms': Milliseconds;
            default: Hertz;
        });
    }

/* === Computed Instance Fields === */
/* === Instance Fields === */

    /* length of time interval (in milliseconds) */
    var time(default, null): Null<Float>;

    /* [this] frequency in Hertz */
    var hertz(default, null): Null<Float>;

    var val(default, null): FreqVal;
    public var unit(default, null): FrequencyUnit;
}

abstract Frequency (FrequencyType) from FrequencyType {
    public inline function new() {

    }
}

enum FrequencyUnit {
    Hertz;
    Kilohertz;
    Midi;
    Samples;

    Seconds;
    Milliseconds;
}

typedef FreqUnit = Either<String, FrequencyUnit>;
typedef FreqVal = Either<FrequencyType, Either<Float, Either<String, {value:FreqVal, ?unit:FreqUnit}>>>;
