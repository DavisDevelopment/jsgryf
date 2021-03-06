package gryffin.audio;

import gryffin.core.Stage;
import gryffin.core.EventDispatcher;
import gryffin.display.*;
import gryffin.media.MediaObject;

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
import tannus.async.*;

import tannus.media.*;
import Math.*;
import tannus.math.TMath.*;
import gryffin.Tools.*;

import tannus.http.Url;

import js.html.audio.AudioContext in NCtx;

using tannus.math.TMath;
using tannus.FunctionTools;

@:access( gryffin.audio.Audio )
class AudioContext {
	/* Constructor Function */
	public function new():Void {
		c = new NCtx();

		destination = new AudioDestination(this, c.destination);
	}

/* === Instance Methods === */

	/**
	  * dispose of [this] Context, releasing any resources that it has allocated
	  */
	public function close(cb : Void->Void):Void {
	    cb = cb.join(function() {
	        trace('AudioContext closed');
	    });
		((untyped c).close() : js.Promise<Dynamic>)
		    .catchError(function(error) {
		        throw error;
		    })
		    .then(untyped cb);
	}

	/**
	  * Create a source node
	  */
	@:access( gryffin.display.Video )
	public function createSource(src : MediaObject):AudioSource {
		var element:Dynamic = src;
		if (Std.is(src, Audio)) {
			element = cast(src, Audio).sound;
		}
		else if (Std.is(src, Video)) {
			element = cast(src, Video).vid;
		}
		return new AudioSource(this, c.createMediaElementSource(cast element));
	}

	/**
	  * Create an Analyser
	  */
	public function createAnalyser():AudioAnalyser {
		return new AudioAnalyser( this );
	}

	/**
	  * Create a channel splitter
	  */
	public function createChannelSplitter(channels : Int):AudioChannelSplitter {
		return new AudioChannelSplitter(this, channels);
	}

	/**
	  * Create a channel merger
	  */
	public function createChannelMerger(channels : Int):AudioChannelMerger {
		return new AudioChannelMerger(this, channels);
	}

    /**
      * create a new AudioBuffer
      */
	public function createBuffer(numberOfChannels:Int, length:Int, sampleRate:Float):AudioBuffer {
		return new AudioBuffer(this, c.createBuffer(numberOfChannels, length, sampleRate));
	}

    /**
      * create an AudioScriptProcessor node
      */
	public function createRawProcessor(?bufferSize:Int, ?inChannels:Int, ?outChannels:Int):RawAudioShader {
		return new RawAudioShader(this, bufferSize, inChannels, outChannels);
	}

    /**
      * create a new AudioShader node
      */
	public function createShader(?bufferSize:Int, ?inChannels:Int, ?outChannels:Int):AudioShader {
		return new AudioShader(this, createRawProcessor(bufferSize, inChannels, outChannels));
	}

	public function createBiquadFilter():AudioBiquadFilter {
	    return new AudioBiquadFilter( this );
	}

	public function createGain():AudioGain {
	    return new AudioGain( this );
		//c.sampleRate
	}

/* === Computed Instance Fields === */

    public var sampleRate(get, never): Float;
    private inline function get_sampleRate() return c.sampleRate;

/* === Instance Fields === */

	public var c : NCtx;
	public var destination : AudioDestination;
}
