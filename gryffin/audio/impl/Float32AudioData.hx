package gryffin.audio.impl;

import tannus.io.*;
import tannus.ds.*;
import tannus.math.*;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

import js.html.Float32Array;
import js.html.ArrayBuffer;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;
using tannus.html.JSTools;

class Float32AudioData implements IAudioData<Float> {
	/* Constructor Function */
	public function new(array : Float32Array):Void {
		d = array;
		buffer = d.buffer;
	}

/* === Instance Methods === */

	public inline function get(i:Int):Float return d[i];
	public inline function set(i:Int, v:Float):Float return (d[i] = v);
	public inline function iterator():Iterator<Float> return new ADIter( this );
	public inline function clone():IAudioData<Float> {
		return new Float32AudioData(new Float32Array(d.buffer.slice( 0 )));
	}
	public inline function slice(start:Int, ?end:Int):IAudioData<Float> return new Float32AudioData(d.subarray(start, end));

	/**
	  * Reverse [this] data, 
	  */
	public function reverse():Void {
		for (i in 0...floor(length / 2)) {
			var temp = get( i );
			set(i, get(length - i - 1));
			set((length - i - 1), temp);
		}
	}

	/**
	  * Create and return a copy of [this] that is inverted
	  */
	public function invert():IAudioData<Float> {
		var id:Float32Array = new Float32Array(d.buffer.slice( 0 ));
		for (i in 0...id.length) {
			id[i] = (255 - id[i]);
		}
		return new Float32AudioData( id );
	}

	/**
	  * Convert [this] into a ByteArray
	  */
	public function getByteArray(?start:Int, ?end:Int):ByteArray {
		if (start == null) start = 0;
		if (end == null) end = (length - 1);
		var len = (end - start);
		var bytes = ByteArray.alloc(4 * len);
		for (i in start...end) {
			bytes.setFloat((i - start), get( i ));
		}
		return bytes;
	}

	/**
	  * Write all or a slice of [this] data onto [other]
	  */
	public inline function writeTo(other:IAudioData<Float>, ?offset:Int, ?start:Int, ?end:Int):Void {
		cast(other, Float32Array).set(d.subarray(start, end), offset);
		/*
		if (start == null) start = 0;
		if (end == null) end = length - 1;
		if (offset == null) offset = 0;

		for (i in start...end) {
			other.set((i + offset), get( i ));
		}
		*/
	}

	/**
	  * Copy [other]s data onto [this]
	  */
	public inline function copyFrom(other:IAudioData<Float>, ?offset:Int, ?start:Int, ?end:Int):Void other.writeTo(this, offset, start, end);

/* === Computed Instance Fields === */

	public var length(get, never):Int;
	private inline function get_length():Int return d.length;

/* === Instance Fields === */

	public var buffer : ArrayBuffer;
	private var d : Float32Array;
}
