package gryffin.audio;

import tannus.io.*;
import tannus.ds.*;
import tannus.math.*;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

import js.html.audio.AnalyserNode;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class CAudioData<T:Float> {
	/* Constructor Function */
	public function new(a : AudioAnalyser):Void {
		analyser = a;
	}

/* === Instance Methods === */

	/**
	  * Copy [this]
	  */
	public function clone():CAudioData<T> {
		return new CAudioData( analyser );
	}

	/**
	  * Get a subset of [this]
	  */
	public function slice(start:Int, ?end:Int):CAudioData<T> {
		return clone();
	}

	/**
	  * Iterate over [this]
	  */
	public function iterator():Iterator<T> {
		return new AudioDataIter( this );
	}

	/* get a value */
	public function get(index : Int):T return d.get( index );

/* === Computed Instance Fields === */

	public var length(get, never):Int;
	private inline function get_length():Int return d.length;

	private var a(get, never):AnalyserNode;
	private inline function get_a():AnalyserNode return analyser.node;

/* === Instance Fields === */

	public var d : TypedArray<T>;
	public var analyser : AudioAnalyser;
}

class AudioDataIter<T:Float> {
	public function new(d : CAudioData<T>):Void {
		i = new IntIterator(0, d.length);
	}

	public inline function hasNext():Bool return i.hasNext();
	public inline function next():T return d.get(i.next());

	public var i : IntIterator;
	public var d : CAudioData<T>;
}
