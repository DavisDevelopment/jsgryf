package gryffin.audio;

import tannus.io.Signal;
import tannus.io.VoidSignal in VSignal;
import tannus.ds.Delta;
import tannus.math.Percent;
import tannus.media.Duration;

import gryffin.core.EventDispatcher;

import js.html.AudioElement;
import js.html.Audio;
import js.html.MediaError;

import Std.*;
import gryffin.Tools.*;

class Sound extends EventDispatcher {
	/* Constructor Function */
	public function new(?s : AudioElement):Void {
		super();

		audio = (s != null ? s : new Audio());
	}

/* === Instance Methods === */

	/**
	  * Create and bind the Signals for the events of [this] Sound
	  */
	private function listen():Void {
		onload = new VSignal();
		onended = new VSignal();
		oncanplay = new VSignal();
		onplay = new VSignal();
		onpause = new VSignal();
		onloadedmetadata = new VSignal();
		onerror = new Signal();
		onprogress = new Signal();
		ondurationchange = new Signal();
		onvolumechange = new Signal();
		onratechange = new Signal();

		var on = audio.addEventListener.bind(_, _);

		on('error', function() onerror.call( audio.error ));
		on('ended', onended.fire);
		on('canplay', oncanplay.fire);
		on('play', onplay.fire);
		on('pause', onpause.fire);
		on('load', onload.fire);
		on('loadedmetadata', onloadedmetadata.fire);

		on('progress', function(e) {
			onprogress.call( 0 );
		});
	}

	/**
	  * Watch for duration-changed events
	  */
	private function durationChanged():Void {
		audio.addEventListener('durationchange', function(event) {
			trace('-- duration changed -- ');
			trace( event );
		});
	}

/* === Computed Instance Fields === */

	/* the current value of the 'src' attribute */
	public var src(get, set):String;
	private inline function get_src():String return string( audio.currentSrc );
	private inline function set_src(v : String):String return (audio.src = v);

	/* the current Duration of [this] shit */
	public var duration(get, never):Duration;
	private inline function get_duration():Duration {
		return Duration.fromSecondsF( audio.duration );
	}

/* === Instance Fields === */
	
	/* == media-event Signals == */
	public var onload : VSignal;
	public var onerror : Signal<MediaError>;
	public var onended : VSignal;
	public var oncanplay : VSignal;
	public var onplay : VSignal;
	public var onpause : VSignal;
	public var onprogress : Signal<Percent>;
	public var onloadedmetadata : VSignal;

	public var ondurationchange : Signal<Delta<Duration>>;
	public var onvolumechange : Signal<Delta<Float>>;
	public var onratechange : Signal<Delta<Float>>;

	/* the underlyin audio */
	private var audio : AudioElement;
}
