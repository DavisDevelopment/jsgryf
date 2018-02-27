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
import js.html.Uint8Array;
import js.html.Float32Array;

using tannus.math.TMath;

class AudioGain extends AudioNode<GainNode> {
    public function new(c: AudioContext) {
        super(c, c.c.createGain());
    }

    public var gain(get, set): Float;
    private inline function get_gain() return node.gain.value;
    private inline function set_gain(v) return (node.gain.value = v);
}
