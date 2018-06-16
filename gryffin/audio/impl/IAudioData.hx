package gryffin.audio.impl;

import js.html.ArrayBuffer;

import tannus.io.ByteArray;

interface IAudioData<T> {
	var length(get, never):Int;
	var buffer : ArrayBuffer;

	function get(i : Int):T;
	function set(i:Int, v:T):T;
	function iterator():Iterator<T>;
	function clone():IAudioData<T>;
	function slice(start:Int, ?end:Int):IAudioData<T>;
	function invert():IAudioData<T>;
	function reverse():Void;
	function writeTo(other:IAudioData<T>, ?destOffset:Int, ?start:Int, ?end:Int):Void;
	function copyFrom(other:IAudioData<T>, ?offset:Int, ?start:Int, ?end:Int):Void;
	function getByteArray(?start:Int, ?end:Int):ByteArray;
	function getData():Dynamic;
}
