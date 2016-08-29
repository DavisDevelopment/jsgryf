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
import js.html.audio.AudioProcessingEvent;
import js.html.audio.ScriptProcessorNode in Spn;
import js.html.Uint8Array;
import js.html.Float32Array;

using tannus.math.TMath;

class RawAudioShader extends AudioNode<Spn> {
	/* Constructor Function */
	public function new(c:AudioContext, ?size:Int, ?ichan:Int, ?ochan:Int):Void {
		super(c, c.c.createScriptProcessor(size, ichan, ochan));
	}

/* === Computed Instance Fields === */

	public var bufferSize(get, never):Int;
	private inline function get_bufferSize():Int return node.bufferSize;

	public var body(get, set):Null<AudioProcessingEvent -> Void>;
	private inline function get_body():Null<AudioProcessingEvent -> Void> return untyped node.onaudioprocess;
	private inline function set_body(v : Null<AudioProcessingEvent -> Void>):Null<AudioProcessingEvent -> Void> {
		return untyped (node.onaudioprocess = v);
	}
}
