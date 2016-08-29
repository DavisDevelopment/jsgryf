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

import js.html.AudioElement in Audel;
import js.html.Audio in Aud;
import js.html.MediaError;

using tannus.math.TMath;

class Audio extends EventDispatcher implements Stateful<AudioState> implements gryffin.media.MediaObject {
	/* Constructor Function */
	public function new(?s : Aud):Void {
		super();

		sound = (s != null ? s : cast createSound());

		onerror = new Signal();
		ondurationchange = new Signal();
		onvolumechange = new Signal();
		onratechange = new Signal();
		onstatechange = new Signal();

		onended = new VSignal();
		oncanplay = new VSignal();
		onplay = new VSignal();
		onpause = new VSignal();
		onload = new VSignal();
		onprogress = new Signal();
		onloadedmetadata = new VSignal();

		listen();
	}

/* === Instance Methods === */

	/**
	  * Destroy [this] Video
	  */
	public function destroy():Void {
		sound.remove();
	}

	/**
	  * Play [this] Video
	  */
	public function play():Void {
		sound.play();
		dispatch('play', null);
	}

	/**
	  * Pause [this] Video
	  */
	public function pause():Void {
		sound.pause();
		dispatch('pause', null);
	}

	/**
	  * Loads the given Url, and alerts the caller when complete
	  */
	public function load(url:String, ?can_manipulate:Void->Void, ?can_play:Void->Void):Void {
		pause();

		src = url;

		onloadedmetadata.once(function() {
			trace( 'soundeo\'s metadata has been loaded' );
			if (can_manipulate != null) {
				can_manipulate();
			}
		});
		oncanplay.once(function() {
			trace('soundeo can be played now');
			if (can_play != null) {
				can_play();
			}
		});
		onerror.once(function(error : Dynamic):Void {
			js.Browser.console.error( error );
		});
	}

	/**
	  * Get a copy of the current state of [this] Video
	  */
	public function getState():AudioState {
		return {
			'volume': volume,
			'speed': playbackRate
		};
	}

	/**
	  * Set the current state of [this] Video
	  */
	public function setState(state : AudioState):Void {
		volume = state.volume;
		playbackRate = state.speed;
	}

	/**
	  * unload the current media and reset the underlying element
	  */
	public function clear():Void {
		var state = getState();
		pause();
		/*
		function del(){
			var me = js.Lib.nativeThis;
			//(untyped __js__('delete'))( me );
			me.remove();
		};
		(untyped del).call( sound );
		*/
		sound.remove();
		sound = null;
		sound = cast createSound();
		setState( state );
	}

	/**
	  * Bind the Signal fields of [this] Video to the underlying events
	  */
	private function listen():Void {
		var on = sound.addEventListener.bind(_, _);

		on('error', function() onerror.call( sound.error ));
		on('ended', onended.fire);
		on('canplay', oncanplay.fire);
		on('play', onplay.fire);
		on('pause', onpause.fire);
		on('load', onload.fire);
		on('progress', function(e) {
			onprogress.call( progress );
		});
		on('loadedmetadata', onloadedmetadata.fire);

		durationChanged();
		volumeChanged();
		rateChanged();
	}

	/* listen to the 'durationchange' Event */
	private function durationChanged():Void {
		var last_duration:Null<Duration> = null;
		sound.addEventListener('durationchange', function() {
			var cur_dur:Duration = Duration.fromSecondsF( sound.duration );
			var delta:Delta<Duration> = new Delta(cur_dur, last_duration);

			ondurationchange.call( delta );

			last_duration = cur_dur;
		});
	}

	/* listen for the 'volumechange' Event */
	private function volumeChanged():Void {
		var last_vol:Null<Float> = volume;
		sound.addEventListener('volumechange', function() {
			var delta = new Delta(volume, last_vol);
			onvolumechange.call( delta );
			onstatechange.call(getState());
			dispatch('volumechange', delta);
			last_vol = volume;
		});
	}

	/* listen for the 'ratechange' Event */
	private function rateChanged():Void {
		var last_rate:Null<Float> = playbackRate;
		sound.addEventListener('ratechange', function() {
			var delta = new Delta(playbackRate, last_rate);
			onratechange.call( delta );
			onstatechange.call(getState());
			dispatch('ratechange', delta);
			last_rate = playbackRate;
		});
	}

/* === Computed Instance Fields === */

	/* the [src] attribute of [this] Video */
	public var src(get, set):String;
	private function get_src():String {
		return Std.string(sound.currentSrc);
	}
	private function set_src(v : String):String {
		sound.src = v.toString();
		return src;
	}

	/* the duration of [this] Video */
	public var duration(get, never):Duration;
	private inline function get_duration():Duration return Duration.fromSecondsF(sound.duration);

	/* the current time of [this] Video */
	public var currentTime(get, set):Float;
	private inline function get_currentTime():Float return (sound.currentTime);
	private inline function set_currentTime(v : Float):Float return (sound.currentTime = v);

	/* the current time of [this] soundeo (as a Duration) */
	public var time(get, set):Duration;
	private inline function get_time():Duration return Duration.fromSecondsF( currentTime );
	private function set_time(v : Duration):Duration {
		currentTime = v.totalSeconds;
		return time;
	}

	/* the current 'progress' of [this] Video */
	public var progress(get, set):Percent;
	private inline function get_progress():Percent {
		return Percent.percent(currentTime, sound.duration);
	}
	private function set_progress(v : Percent):Percent {
		currentTime = v.of( sound.duration );
		return progress;
	}

	/* the playbackRate of [this] Video */
	public var playbackRate(get, set):Float;
	private inline function get_playbackRate():Float return (sound.playbackRate);
	private function set_playbackRate(v : Float):Float {
		sound.playbackRate = v;
		sound.playbackRate = (round(sound.playbackRate * 100) / 100);
		return sound.playbackRate;
	}

	/* whether [this] Video is currently paused */
	public var paused(get, never):Bool;
	private inline function get_paused():Bool return sound.paused;

	/* the volume of [this] Video */
	public var volume(get, set):Float;
	private inline function get_volume() return sound.volume;
	private function set_volume(v : Float):Float {
		return (sound.volume = v.clamp(0, 1));
	}

	/* whether [this] Video is currently muted */
	public var muted(get, set):Bool;
	private inline function get_muted() return sound.muted;
	private inline function set_muted(v : Bool) return (sound.muted = v);

	public var buffered(get, never):TimeRanges;
	private inline function get_buffered():TimeRanges return sound.buffered;
	public var played(get, never):TimeRanges;
	private inline function get_played():TimeRanges return sound.played;

/* === Instance Fields === */

	/* the VideoElement in use by [this] object */
	private var sound : Aud;

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
	public var onstatechange : Signal<AudioState>;

/* === Static Methods === */

	/**
	  * Create and return a new Vid object
	  */
	private static inline function createSound():Audel {
		return js.Browser.document.createAudioElement();
	}

	private static inline var FPS : Int = 30;
}

typedef AudioState = {
	volume : Float,
	speed : Float
};
