package gryffin.audio.impl;

import tannus.io.*;
import tannus.ds.*;
import tannus.math.*;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

import js.html.Uint8Array;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class ByteAudioData extends CAudioData<Int> {
	/* Constructor Function */
	public function new(c:AudioAnalyser, array:Uint8Array):Void {
		super( c );
		d = untyped array;
	}

/* === Instance Methods === */

	/**
	  * Create and return a copy of [this]
	  */
	override public function clone():CAudioData<Int> {
		return new ByteAudioData(analyser, untyped d.subarray( 0 ));
	}

	/**
	  * Create and return a subset of [this]
	  */
	override public function slice(start:Int, ?end:Int):CAudioData<Int> {
		return new ByteAudioData(analyser, untyped d.subarray(start, end));
	}
}
