package gryffin.audio;

import tannus.io.*;
import tannus.ds.*;
import tannus.math.*;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

import gryffin.audio.impl.*;

import js.html.Uint8Array;
import js.html.Float32Array;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

@:forward
abstract AudioData<T:Float> (CAudioData<T>) from CAudioData<T> to CAudioData<T> {
	/* Constructor Function */
	public inline function new(fd : CAudioData<T>):Void {
		this = fd;
	}

/* === Instance Methods === */

	@:arrayAccess
	public inline function get(i : Int):T return this.get( i );

/* === Factory Methods === */

	public static inline function byte(a:AudioAnalyser, l:Uint8Array):AudioData<Int> return new ByteAudioData(a, l);
	public static inline function float(a:AudioAnalyser, l:Float32Array):AudioData<Float> return new FloatAudioData(a, l);
}
