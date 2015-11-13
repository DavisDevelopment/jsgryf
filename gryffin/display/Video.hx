package gryffin.display;

import gryffin.core.Stage;
import gryffin.display.*;

import tannus.geom.*;
import tannus.math.Percent;
import tannus.io.Signal;
import tannus.io.VoidSignal in VSignal;
import tannus.ds.Delta;
import tannus.ds.AsyncStack;

import tannus.media.*;

import tannus.http.Url;

import js.html.VideoElement in Vid;
import js.html.MediaError;

class Video implements Paintable {
	/* Constructor Function */
	public function new(?el : Vid):Void {
		vid = (el != null ? el : createVid());

		onerror = new Signal();
		ondurationchange = new Signal();
		onvolumechange = new Signal();
		onratechange = new Signal();

		onended = new VSignal();
		oncanplay = new VSignal();
		onplay = new VSignal();
		onpause = new VSignal();
		onload = new VSignal();

		listen();
	}

/* === Instance Methods === */

	/**
	  * Destroy [this] Video
	  */
	public function destroy():Void {
		vid.remove();
	}

	/**
	  * Paint [this] Video onto a Canvas
	  */
	public function paint(c:Ctx, s:Rectangle, d:Rectangle):Void {
		c.drawImage(vid, s.x, s.y, s.w, s.h, d.x, d.y, d.w, d.h);
	}

	/**
	  * Play [this] Video
	  */
	public function play():Void {
		vid.play();
	}

	/**
	  * Pause [this] Video
	  */
	public function pause():Void {
		vid.pause();
	}

	/**
	  * Loads the given Url, and alerts the caller when complete
	  */
	public function load(url:Url, cb:Void->Void):Void {
		pause();

		onload.once(function() trace('VIDEO LOADED'));
		oncanplay.once( cb );
		onerror.once(function(error : Dynamic):Void {
			js.Browser.console.error( error );
			cb();
		});
		
		src = url;
	}

	/**
	  * Bind the Signal fields of [this] Video to the underlying events
	  */
	private function listen():Void {
		var on = vid.addEventListener.bind(_, _);

		on('error', function() onerror.call( vid.error ));
		on('ended', onended.fire);
		on('canplay', oncanplay.fire);
		on('play', onplay.fire);
		on('pause', onpause.fire);
		on('load', onload.fire);

		durationChanged();
		volumeChanged();
		//rateChanged();
	}

	/* listen to the 'durationchange' Event */
	private function durationChanged():Void {
		var last_duration:Null<Duration> = null;
		vid.addEventListener('durationchange', function() {
			var cur_dur:Duration = Duration.fromSecondsF( vid.duration );
			var delta:Delta<Duration> = new Delta(cur_dur, last_duration);

			ondurationchange.call( delta );

			last_duration = cur_dur;
		});
	}

	/* listen for the 'volumechange' Event */
	private function volumeChanged():Void {
		var last_vol:Null<Float> = volume;
		vid.addEventListener('volumechange', function() {
			var delta = new Delta(volume, last_vol);
			onvolumechange.call( delta );
			last_vol = volume;
		});
	}

/* === Computed Instance Fields === */

	/* the width of [this] Video */
	public var width(get, never):Int;
	private inline function get_width():Int return (vid.videoWidth);
	
	/* the height of [this] Video */
	public var height(get, never):Int;
	private inline function get_height():Int return (vid.videoHeight);

	/* the rect of [this] Video */
	public var rect(get, never):Rectangle;
	private function get_rect():Rectangle {
		return new Rectangle(0, 0, width, height);
	}

	/* the [src] attribute of [this] Video */
	public var src(get, set):Url;
	private function get_src():Url {
		return new Url( vid.currentSrc );
	}
	private function set_src(v : Url):Url {
		vid.src = v.toString();
		return src;
	}

	/* the duration of [this] Video */
	public var duration(get, never):Duration;
	private inline function get_duration():Duration return Duration.fromSecondsF(vid.duration);

	/* the current time of [this] Video */
	public var currentTime(get, set):Float;
	private inline function get_currentTime():Float return (vid.currentTime);
	private inline function set_currentTime(v : Float):Float return (vid.currentTime = v);

	/* the current 'progress' of [this] Video */
	public var progress(get, never):Percent;
	private inline function get_progress():Percent {
		return Percent.percent(currentTime, vid.duration);
	}

	/* the playbackRate of [this] Video */
	public var playbackRate(get, set):Float;
	private inline function get_playbackRate():Float return (vid.playbackRate);
	private inline function set_playbackRate(v : Float):Float return (vid.playbackRate = v);

	/* whether [this] Video is currently paused */
	public var paused(get, never):Bool;
	private inline function get_paused():Bool return vid.paused;

	/* the volume of [this] Video */
	public var volume(get, set):Float;
	private inline function get_volume() return vid.volume;
	private inline function set_volume(v : Float):Float return (vid.volume = v);

/* === Instance Fields === */

	/* the VideoElement in use by [this] object */
	private var vid : Vid;

	/* == media-event Signals == */
	public var onload : VSignal;
	public var onerror : Signal<MediaError>;
	public var onended : VSignal;
	public var oncanplay : VSignal;
	public var onplay : VSignal;
	public var onpause : VSignal;

	public var ondurationchange : Signal<Delta<Duration>>;
	public var onvolumechange : Signal<Delta<Float>>;
	public var onratechange : Signal<Delta<Float>>;

/* === Static Methods === */

	/**
	  * Create and return a new Vid object
	  */
	private static inline function createVid():Vid {
		return js.Browser.document.createVideoElement();
	}
}
