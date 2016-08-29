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
import js.html.audio.AudioBuffer in Buff;
import js.html.Uint8Array;
import js.html.Float32Array;

using tannus.math.TMath;

class AudioBuffer {
	/* Constructor Function */
	public function new(c:AudioContext, b:Buff):Void {
		node = b;
		ctx = c;
	}

/* === Instance Methods === */

	public function getChannelData(channelIndex : Int):AudioData<Float> {
		var fa = node.getChannelData( channelIndex );
		var ad = AudioData.float( fa );
		return ad;
	}

	public function channels():Iterator<AudioData<Float>> {
		return new BufferChannelIter( this );
	}

/* === Computed Instance Fields === */

	public var sampleRate(get, never):Float;
	private inline function get_sampleRate():Float return node.sampleRate;
	
	public var duration(get, never):Float;
	private inline function get_duration():Float return node.duration;
	
	public var length(get, never):Int;
	private inline function get_length():Int return node.length;
	
	public var numberOfChannels(get, never):Int;
	private inline function get_numberOfChannels():Int return node.numberOfChannels;

/* === Instance Fields === */

	public var ctx : AudioContext;
	public var node : Buff;
}

private class BufferChannelIter {
	private var b : AudioBuffer;
	private var i : IntIterator;
	public inline function new(buffer : AudioBuffer):Void {
		b = buffer;
		i = (0...b.numberOfChannels);
	}
	public inline function hasNext():Bool return i.hasNext();
	public inline function next():AudioData<Float> return b.getChannelData(i.next());
}
