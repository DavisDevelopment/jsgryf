package gryffin.display;

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

import js.html.VideoElement in Vid;
import js.html.MediaError;

using tannus.math.TMath;

class Video extends EventDispatcher implements Paintable implements Stateful<VideoState> implements gryffin.media.MediaObject {
	/* Constructor Function */
	public function new(?el : Vid):Void {
		super();

		vid = (el != null ? el : createVid());

		onerror = new Signal();
		ondurationchange = new Signal();
		onvolumechange = new Signal();
		onratechange = new Signal();
		onstatechange = new Signal();

		onseekbegin = new VSignal();
		onseekend = new VSignal();

		onended = new VSignal();
		oncanplay = new VSignal();
		onplay = new VSignal();
		onpause = new VSignal();
		onload = new VSignal();
		onprogress = new Signal();
		onloadeddata = new VSignal();
		onloadedmetadata = new VSignal();

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
		if ( ready ) {
			c.drawImage(vid, s.x, s.y, s.w, s.h, d.x, d.y, d.w, d.h);
		}
		else {
			c.save();
			c.beginPath();
			c.fillStyle = 'black';
			c.drawRect( d );
			c.closePath();
			c.fill();
			c.restore();
		}
	}

	/**
	  * Capture [this] Video onto a Canvas
	  */
	public function capture(x:Int=0, y:Int=0, ?w:Int, ?h:Int):Canvas {
		if (w == null)
			w = (width - x);
		if (h == null)
			h = (height - y);

		var canvas:Canvas = Canvas.create(w, h);
		canvas.context.drawImage(vid, x, y, width, height, 0, 0, w, h);
		return canvas;
	}

	/**
	  * Create a deep copy of [this]
	  */
	public function clone():Video {
		var ce = vid.cloneNode( true );
		var cv = new Video(cast ce);
		return cv;
	}

	/**
	  * Get 'all' frames of [this] Video
	  */
	public function frames(jumpSeconds:Int, oncapture:Int -> Canvas -> Void):ArrayPromise<Canvas> {
		return Promise.create({
			var stack = new AsyncStack();
			var results = new Array();
			var i:Int = 0;
			var len:Int = duration.totalSeconds;
			while (i < len) {
				stack.push(function( next ) {
					get_frame(i.clamp(0, len), results, function( canvas ) {
						oncapture(i, canvas);
						next();
					});
				});

				i += jumpSeconds;
			}
			stack.run(function() return results);
		}).array();
	}

	private function get_frame(n:Int, list:Array<Canvas>, done:Canvas->Void):Void {
		defer(function() {
			currentTime = n;
			oncanplay.once(function() {
				var c = capture();
				list.push( c );
				done( c );
			});
		});
	}

	/**
	  * get the approximate number of frames in [this] Video
	  */
	public function frameCount():Int {
		return (duration.totalSeconds * FPS);
	}

	/**
	  * get the index of the current frame
	  */
	public function currentFrame():Int {
		var ct:Duration = currentTime;
		return (ct.totalSeconds * FPS);
	}

	/**
	  * jump to the given frame
	  */
	public function gotoFrame(frameIndex : Int):Void {
		var frameTime:Float = (1.0 / FPS);
		currentTime = (frameIndex * frameTime);
	}

	/**
	  * Play [this] Video
	  */
	public function play():Void {
		vid.play();
		dispatch('play', null);
	}

	/**
	  * Pause [this] Video
	  */
	public function pause():Void {
		vid.pause();
		dispatch('pause', null);
	}

	/**
	  * Loads the given Url, and alerts the caller when complete
	  */
	public function load(url:String, ?can_manipulate:Void->Void, ?can_play:Void->Void):Void {
		pause();

		src = url;

		onloadedmetadata.once(function() {
			trace( 'video\'s metadata has been loaded' );
			if (can_manipulate != null) {
				can_manipulate();
			}
		});
		oncanplay.once(function() {
			trace('video can be played now');
			if (can_play != null) {
				can_play();
			}
		});
		onerror.once(function(error : Dynamic):Void {
			js.Browser.console.error( error );
		});
	}

	/**
	  * Seek [this] Video to the given position
	  */
	public function seek(time:Float, ?callback:Void->Void):Void {
		if (callback != null) {
			onseekend.once( callback );
		}

		currentTime = time;
	}

	/**
	  * Get a copy of the current state of [this] Video
	  */
	public function getState():VideoState {
		return {
			'volume': volume,
			'speed': playbackRate
		};
	}

	/**
	  * Set the current state of [this] Video
	  */
	public function setState(state : VideoState):Void {
		volume = state.volume;
		playbackRate = state.speed;
	}

	/**
	  * unload the current media and reset the underlying element
	  */
	public function clear():Void {
		var state = getState();
		pause();
		vid.remove();
		vid = null;
		vid = createVid();
		setState( state );
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
		on('progress', function(e) {
			onprogress.call( progress );
		});
		on('loadeddata', onloadeddata.fire);
		on('loadedmetadata', onloadedmetadata.fire);

		on('seeking', onseekbegin.fire);
		on('seeked', onseekend.fire);

		durationChanged();
		volumeChanged();
		rateChanged();

		onloadedmetadata.once(function() {
			width = naturalWidth;
			height = naturalHeight;
		});
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
			onstatechange.call(getState());
			dispatch('volumechange', delta);
			last_vol = volume;
		});
	}

	/* listen for the 'ratechange' Event */
	private function rateChanged():Void {
		var last_rate:Null<Float> = playbackRate;
		vid.addEventListener('ratechange', function() {
			var delta = new Delta(playbackRate, last_rate);
			onratechange.call( delta );
			onstatechange.call(getState());
			dispatch('ratechange', delta);
			last_rate = playbackRate;
		});
	}

/* === Computed Instance Fields === */

	/* the width of [this] Video */
	public var width(get, set):Int;
	private inline function get_width():Int return (vid.width);
	private inline function set_width(v : Int):Int return (vid.width = v);
	
	/* the height of [this] Video */
	public var height(get, set):Int;
	private inline function get_height():Int return (vid.height);
	private inline function set_height(v : Int):Int return (vid.height = v);

	public var naturalWidth(get, never):Int;
	private inline function get_naturalWidth():Int return vid.videoWidth;

	public var naturalHeight(get, never):Int;
	private inline function get_naturalHeight():Int return vid.videoHeight;

	/* the rect of [this] Video */
	public var rect(get, never):Rectangle;
	private function get_rect():Rectangle {
		return new Rectangle(0, 0, width, height);
	}

	/* the [src] attribute of [this] Video */
	public var src(get, set):String;
	private function get_src():String {
		return Std.string(vid.currentSrc);
	}
	private function set_src(v : String):String {
		vid.src = v.toString();
		ready = false;
		onloadedmetadata.once(function() {
			ready = true;
		});
		return src;
	}

	/* the duration of [this] Video */
	public var duration(get, never):Duration;
	private inline function get_duration():Duration return Duration.fromSecondsF(vid.duration);

	/* the current time of [this] Video */
	public var currentTime(get, set):Float;
	private inline function get_currentTime():Float return (vid.currentTime);
	private inline function set_currentTime(v : Float):Float return (vid.currentTime = v);

	/* the current time of [this] video (as a Duration) */
	public var time(get, set):Duration;
	private inline function get_time():Duration return Duration.fromSecondsF( currentTime );
	private function set_time(v : Duration):Duration {
		currentTime = v.totalSeconds;
		return time;
	}

	/* the current 'progress' of [this] Video */
	public var progress(get, set):Percent;
	private inline function get_progress():Percent {
		return Percent.percent(currentTime, vid.duration);
	}
	private function set_progress(v : Percent):Percent {
		currentTime = v.of( vid.duration );
		return progress;
	}

	/* the playbackRate of [this] Video */
	public var playbackRate(get, set):Float;
	private inline function get_playbackRate():Float return (vid.playbackRate);
	private function set_playbackRate(v : Float):Float {
		vid.playbackRate = v;
		vid.playbackRate = (round(vid.playbackRate * 100) / 100);
		return vid.playbackRate;
	}

	/* whether [this] Video is currently paused */
	public var paused(get, never):Bool;
	private inline function get_paused():Bool return vid.paused;

	/* the volume of [this] Video */
	public var volume(get, set):Float;
	private inline function get_volume() return vid.volume;
	private function set_volume(v : Float):Float {
		return (vid.volume = v.clamp(0, 1));
	}

	/* whether [this] Video is currently muted */
	public var muted(get, set):Bool;
	private inline function get_muted() return vid.muted;
	private inline function set_muted(v : Bool) return (vid.muted = v);

	public var buffered(get, never):TimeRanges;
	private inline function get_buffered():TimeRanges return vid.buffered;
	public var played(get, never):TimeRanges;
	private inline function get_played():TimeRanges return vid.played;

	public var aspectRatio(get, never):Ratio;
	private inline function get_aspectRatio():Ratio {
		return new Ratio(vid.videoWidth, vid.videoHeight);
	}

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
	public var onprogress : Signal<Percent>;
	public var onloadeddata : VSignal;
	public var onloadedmetadata : VSignal;

	public var onseekbegin : VSignal;
	public var onseekend : VSignal;

	public var ondurationchange : Signal<Delta<Duration>>;
	public var onvolumechange : Signal<Delta<Float>>;
	public var onratechange : Signal<Delta<Float>>;
	public var onstatechange : Signal<VideoState>;

	private var ready : Bool = false;

/* === Static Methods === */

	/**
	  * Create and return a new Vid object
	  */
	private static inline function createVid():Vid {
		return js.Browser.document.createVideoElement();
	}

	private static inline var FPS : Int = 30;
}

typedef VideoState = {
	volume : Float,
	speed : Float
};
