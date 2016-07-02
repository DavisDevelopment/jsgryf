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
import js.html.audio.AnalyserNode;
import js.html.Uint8Array;
import js.html.Float32Array;

using tannus.math.TMath;

class AudioAnalyser extends AudioNode<AnalyserNode> {
	/* Constructor Function */
	public function new(c : AudioContext):Void {
		super(c, c.c.createAnalyser());
	}

/* === Instance Methods === */

	/**
	  * Get the current frequency data, as bytes
	  */
	public function getByteFrequencyData():AudioData<Int> {
		var d = new Uint8Array( frequencyCount );
		node.getByteFrequencyData( d );
		return AudioData.byte(this, d);
	}

	/**
	  * Get the current frequency data, as floats
	  */
	public function getFloatFrequencyData():AudioData<Float> {
		var d = new Float32Array( frequencyCount );
		node.getFloatFrequencyData( d );
		return AudioData.float(this, d);
	}

	/**
	  * Get the current waveform data, as bytes
	  */
	public function getByteTimeDomainData():AudioData<Int> {
		var d = new Uint8Array( frequencyCount );
		node.getByteTimeDomainData( d );
		return AudioData.byte(this, d);
	}

	/**
	  * Get the current waveform data, as floats
	  */
	public function getFloatTimeDomainData():AudioData<Float> {
		var d = new Float32Array( frequencyCount );
		node.getFloatTimeDomainData( d );
		return AudioData.float(this, d);
	}

/* === Computed Instance Fields === */

	public var minDecibels(get, never):Float;
	private inline function get_minDecibels():Float return node.minDecibels;
	
	public var maxDecibels(get, never):Float;
	private inline function get_maxDecibels():Float return node.maxDecibels;

	public var decibelRange(get, never):FloatRange;
	private inline function get_decibelRange():FloatRange {
		return new FloatRange(minDecibels, maxDecibels);
	}

	public var frequencyCount(get, never):Int;
	private inline function get_frequencyCount():Int return node.frequencyBinCount;

/* === Instance Fields === */
}
