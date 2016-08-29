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

import js.html.audio.AudioProcessingEvent;
import js.html.Uint8Array;
import js.html.Float32Array;

using tannus.math.TMath;

class AudioShaderScope {
	/* Constructor Function */
	public function new(s:AudioShader, e:AudioProcessingEvent):Void {
		shader = s;
		event = e;

		input = new AudioBuffer(shader.ctx, event.inputBuffer);
		output = new AudioBuffer(shader.ctx, event.outputBuffer);
	}

/* === Instance Methods === */



/* === Instance Fields === */

	public var input : AudioBuffer;
	public var output : AudioBuffer;

	private var shader : AudioShader;
	private var event : AudioProcessingEvent;
}
