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

import js.html.audio.AudioNode in NNode;
import js.html.audio.AudioContext in NCtx;
import js.html.audio.AudioProcessingEvent;
import js.html.audio.ScriptProcessorNode in Spn;
import js.html.Uint8Array;
import js.html.Float32Array;

using tannus.math.TMath;

class AudioShader extends AudioNode<Spn> {
	/* Constructor Function */
	public function new(c:AudioContext, ras:RawAudioShader):Void {
		super(c, ras.node);

		raw = ras;
		processEvent = new Signal();

		raw.body = _bod;
	}

/* === Instance Methods === */

	/**
	  * maps data from [raw] into an AudioShaderScope
	  */
	private function _bod(e : AudioProcessingEvent):Void {
		var scope = new AudioShaderScope(this, e);

		processEvent.call( scope );

		//trace(e.outputBuffer.getChannelData(0));
		if (logs < 100) {
			trace(scope.output.getChannelData( 0 ));
			logs++;
		}
	}

	/* get underlying AudioNode */
	override private function conode():Spn {
		return raw.conode();
	}

/* === Instance Fields === */

	public var raw : RawAudioShader;
	public var processEvent : Signal<AudioShaderScope>;
	private var logs : Int = 0;
}
