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
abstract AudioData<T:Float> (IAudioData<T>) from IAudioData<T> to IAudioData<T> {
	/* Constructor Function */
	public inline function new(fd : IAudioData<T>):Void {
		this = fd;
	}

/* === Instance Methods === */

	@:arrayAccess
	public inline function get(i : Int):T return this.get( i );	
	@:arrayAccess
	public inline function set(i:Int, v:T):T return this.set(i, v);
	public inline function clone():AudioData<T> return this.clone();
	public inline function slice(start:Int, ?end:Int):AudioData<T> return this.slice(start, end);
	public inline function invert():AudioData<T> return this.invert();
	public inline function writeTo(other:AudioData<T>, ?offset:Int, ?start:Int, ?end:Int):Void this.writeTo(other, offset, start, end);
	public inline function copyFrom(other:AudioData<T>, ?offset:Int, ?start:Int, ?end:Int):Void this.copyFrom(other, offset, start, end);

	@:to
	public inline function toByteArray():ByteArray return this.getByteArray();

/* === Factory Methods === */

	@:from
	public static inline function byte(l : Uint8Array):AudioData<Int> {
		return new ByteAudioData( l );
	}

	@:from
	public static inline function float(l : Float32Array):AudioData<Float> {
		return new Float32AudioData( l );
	}
}
