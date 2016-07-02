package gryffin.audio;

import gryffin.core.Stage;
import gryffin.core.EventDispatcher;
import gryffin.display.*;

import tannus.geom.*;
import tannus.math.Percent;
import tannus.io.Signal;
import tannus.io.VoidSignal in VSignal;
import tannus.ds.Delta;
import tannus.ds.AsyncStack;
import tannus.ds.AsyncPool;
import tannus.ds.Promise; import tannus.ds.Stateful;
import tannus.ds.promises.*;
import tannus.math.Ratio;

import tannus.media.*;
import Math.*;
import tannus.math.TMath.*;
import gryffin.Tools.*;

import tannus.http.Url;

import js.html.audio.AudioContext in NCtx;

using tannus.math.TMath;

@:access( gryffin.audio.Audio )
class AudioContext {
	/* Constructor Function */
	public function new():Void {
		c = new NCtx();
		destination = new AudioDestination(this, c.destination);
	}

/* === Instance Methods === */

	/**
	  * Create a source node
	  */
	public function createSource(audio : Audio):AudioSource {
		return new AudioSource(this, c.createMediaElementSource( audio.sound ));
	}

	/**
	  * Create an Analyser
	  */
	public function createAnalyser():AudioAnalyser {
		return new AudioAnalyser( this );
	}

/* === Instance Fields === */

	public var c : NCtx;
	public var destination : AudioDestination;
}
