package gryffin.audio.impl;

import tannus.io.*;
import tannus.ds.*;
import tannus.math.*;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

import js.html.Float32Array;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class FloatAudioData extends CAudioData<Float> {
	/* Constructor Function */
	public function new(c:AudioAnalyser, array:Float32Array):Void {
		super( c );
		d = untyped array;
	}

/* === Instance Methods === */

	/**
	  * Create and return a copy of [this]
	  */
	override public function clone():CAudioData<Float> {
		return new FloatAudioData(analyser, untyped d.subarray( 0 ));
	}

	/**
	  * Create and return a subset of [this]
	  */
	override public function slice(start:Int, ?end:Int):CAudioData<Float> {
		return new FloatAudioData(analyser, untyped d.subarray(start, end));
	}
}
