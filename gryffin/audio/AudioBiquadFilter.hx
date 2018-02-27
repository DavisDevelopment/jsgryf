package gryffin.audio;

import gryffin.core.Stage;
import gryffin.core.EventDispatcher;
import gryffin.display.*;

import tannus.geom.*;
import tannus.math.*;
import tannus.io.*;
import tannus.ds.*;

import tannus.media.*;
import Math.*;
import tannus.math.TMath.*;
import gryffin.Tools.*;

import tannus.http.Url;

import js.html.audio.AudioContext in NCtx;
import js.html.audio.GainNode;
import js.html.audio.BiquadFilterNode;
import js.html.audio.BiquadFilterType as Bft;
import js.html.Uint8Array;
import js.html.Float32Array;

using tannus.math.TMath;

class AudioBiquadFilter extends AudioNode<BiquadFilterNode> {
    public function new(c: AudioContext) {
        super(c, c.c.createBiquadFilter());
    }

/* === Computed Instance Fields === */

    public var stype(get, set): String;
    private inline function get_stype() return (untyped node.type);
    private inline function set_stype(v: String) return (untyped node.type = v);

    public var type(get, set): BiquadFilterType;
    private inline function get_type() return untyped stype;
    private inline function set_type(v) return cast (stype = untyped v);

    public var frequency(get, set): Float;
    private inline function get_frequency() return node.frequency.value;
    private inline function set_frequency(v) return (node.frequency.value = v);

    public var gain(get, set): Float;
    private inline function get_gain() return node.gain.value;
    private inline function set_gain(v) return (node.gain.value = v);

    public var detune(get, set): Float;
    private inline function get_detune() return node.detune.value;
    private inline function set_detune(v) return (node.detune.value = v);

    public var q(get, set): Float;
    private inline function get_q() return node.Q.value;
    private inline function set_q(v) return (node.Q.value = v);
}

@:enum
abstract BiquadFilterType (String) from String to String {
    var Lowpass = 'lowpass';
    var Highpass = 'highpass';
    var Bandpass = 'bandpass';
    var Lowshelf = 'lowshelf';
    var Highshelf = 'highshelf';
    var Peaking = 'peaking';
    var Notch = 'notch';
    var Allpass = 'allpass';
}
