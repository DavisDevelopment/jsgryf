package gryffin.audio;

import js.html.audio.ChannelSplitterNode in Splitter;

class AudioChannelSplitter extends AudioNode<Splitter> {
	/* Constructor Function */
	public function new(c:AudioContext, count:Int):Void {
		super(c, c.c.createChannelSplitter( count ));
	}

/* === Instance Fields === */

	public var channels(get, never):Int;
	private inline function get_channels():Int return node.channelCount;
}
