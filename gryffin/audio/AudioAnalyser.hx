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
	public inline function getByteFrequencyData(?b: AudioData<Int>):AudioData<Int> {
	    var a = ensureByte( b );
		node.getByteFrequencyData( a );
		return AudioData.byte( a );
	}

	/**
	  * Get the current frequency data, as floats
	  */
	public inline function getFloatFrequencyData(?b: AudioData<Float>):AudioData<Float> {
	    var a = ensureFloat( b );
		node.getFloatFrequencyData( a );
		return AudioData.float( a );
	}

	/**
	  * Get the current waveform data, as bytes
	  */
	public inline function getByteTimeDomainData(?b: AudioData<Int>):AudioData<Int> {
		var a = ensureByte( b );
		node.getByteTimeDomainData( a );
		return AudioData.byte( a );
	}

	/**
	  * Get the current waveform data, as floats
	  */
	public inline function getFloatTimeDomainData(?b: AudioData<Float>):AudioData<Float> {
		var a = ensureFloat( b );
		node.getFloatTimeDomainData( a );
		return AudioData.float( a );
	}

	public inline function createFloatData(size: Int):AudioData<Float> {
	    return AudioData.allocFloat( size );
	}
	public inline function createByteData(size: Int):AudioData<Int> {
	    return AudioData.allocByte( size );
	}

	private inline function ensureCache():Void {
		if (f32 == null || f32.length != frequencyCount) {
			f32 = new Float32Array( frequencyCount );
		}
		if (ui8 == null || ui8.length != frequencyCount) {
			ui8 = new Uint8Array( frequencyCount );
		}
	}

	private inline function ensureFloat(?fl: AudioData<Float>):Float32Array {
	    if (fl != null && fl.length == frequencyCount) {
	        return fl.toFloat32Array();
	    }
        else {
            ensureCache();
            return f32;
        }
	}

	private inline function ensureByte(?b: AudioData<Int>):Uint8Array {
	    if (b != null && b.length == frequencyCount) {
	        return b.toUint8Array();
	    }
        else {
            ensureCache();
            return ui8;
        }
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

	public var fftSize(get, set):Int;
	private inline function get_fftSize():Int return node.fftSize;
	private inline function set_fftSize(v : Int):Int return (node.fftSize = v);

	public var smoothing(get, set):Float;
	private inline function get_smoothing():Float return node.smoothingTimeConstant;
	private inline function set_smoothing(v : Float):Float return (node.smoothingTimeConstant = v);

/* === Instance Fields === */

	private var f32 : Null<Float32Array> = null;
	private var ui8 : Null<Uint8Array> = null;
}
