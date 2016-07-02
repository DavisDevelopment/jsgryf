package gryffin.media;

import tannus.media.Duration;
import tannus.media.TimeRanges;
import tannus.io.Signal;
import tannus.io.VoidSignal;
import tannus.ds.Delta;
import tannus.math.Percent;

import js.html.MediaError;

interface MediaObject {
	var onload : VoidSignal;
	var onerror : Signal<MediaError>;
	var onended : VoidSignal;
	var oncanplay : VoidSignal;
	var onplay : VoidSignal;
	var onpause : VoidSignal;
	var onprogress : Signal<Percent>;
	var onloadedmetadata : VoidSignal;
	var ondurationchange : Signal<Delta<Duration>>;
	var onvolumechange : Signal<Delta<Float>>;
	var onratechange : Signal<Delta<Float>>;
	var src(get, set):String;
	var duration(get, never):Duration;
	var currentTime(get, set):Float;
	var time(get, set):Duration;
	var progress(get, set):Percent;
	var playbackRate(get, set):Float;
	var paused(get, never):Bool;
	var volume(get, set):Float;
	var muted(get, set):Bool;
	var buffered(get, never):TimeRanges;
	var played(get, never):TimeRanges;

	function destroy():Void;
	function play():Void;
	function pause():Void;
	function load(url:String, ?can_manipulate:Void->Void, ?can_play:Void->Void):Void;
}
