package gryffin.audio.impl;

import tannus.io.*;
import tannus.ds.*;
import tannus.math.*;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

import js.html.Uint8Array;
import js.html.ArrayBuffer;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;
using tannus.html.JSTools;
using tannus.FunctionTools;

class ByteAudioData implements IAudioData<Int> {
	/* Constructor Function */
	public function new(array : Uint8Array):Void {
		d = array;
		buffer = d.buffer;
	}

/* === Instance Methods === */

	public inline function get(i:Int):Int return d[i];
	public inline function set(i:Int, v:Int):Int return (d[i] = v);
	public inline function iterator():Iterator<Int> return new ADIter( this );
	public inline function clone():IAudioData<Int> {
		return new ByteAudioData(new Uint8Array(d.buffer.slice( 0 )));
	}
	public inline function slice(start:Int, ?end:Int):IAudioData<Int> return new ByteAudioData(d.subarray(start, end));

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
	public function invert():IAudioData<Int> {
		var id:Uint8Array = new Uint8Array(d.buffer.slice( 0 ));
		for (i in 0...id.length) {
			id[i] = (255 - id[i]);
		}
		return new ByteAudioData( id );
	}

	/**
	  * Convert [this] into a ByteArray
	  */
	public function getByteArray(?start:Int, ?end:Int):ByteArray {
		var clone_d:Uint8Array = new Uint8Array(d.subarray(start, end).arrayify());
#if node
        return ByteArray.ofData(new tannus.node.Buffer(untyped clone_d));
#else
		return ByteArray.ofData( clone_d.buffer );
#end
	}

	/**
	  * Write all or a slice of [this] data onto [other]
	  */
	public function writeTo(other:IAudioData<Int>, ?offset:Int, ?start:Int, ?end:Int):Void {
		if (start == null) start = 0;
		if (end == null) end = length - 1;
		if (offset == null) offset = 0;

		for (i in start...end) {
			other.set((i + offset), get( i ));
		}
	}

	/**
	  * Copy [other]s data onto [this]
	  */
	public inline function copyFrom(other:IAudioData<Int>, ?offset:Int, ?start:Int, ?end:Int):Void other.writeTo(this, offset, start, end);

	public static inline function alloc(size: Int):ByteAudioData {
	    return new ByteAudioData(new Uint8Array( size ));
	}

	public inline function getData():Dynamic return d;

/* === Computed Instance Fields === */

	public var length(get, never):Int;
	private inline function get_length():Int return d.length;

/* === Instance Fields === */

	public var buffer : ArrayBuffer;
	private var d : Uint8Array;
}
