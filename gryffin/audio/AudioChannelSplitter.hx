package gryffin.audio;

import js.html.audio.AudioNode in NNode;

import js.html.audio.ChannelSplitterNode in Splitter;

class AudioChannelSplitter extends AudioNode<Splitter> {
	/* Constructor Function */
	public function new(c:AudioContext, count:Int):Void {
		super(c, c.c.createChannelSplitter( count ));
	}

/* === Instance Methods === */

	/**
	  * Connect a Node to [this] on a particular channel
	  */
	public inline function connectChannel<T:NNode>(node:AudioNode<T>, channel:Int):Void {
		connect(node, [channel]);
	}

/* === Instance Fields === */

	public var channels(get, never):Int;
	private inline function get_channels():Int return node.channelCount;
}
