package gryffin.audio;

import js.html.audio.ChannelMergerNode in Merger;

class AudioChannelMerger extends AudioNode<Merger> {
	/* Constructor Function */
	public function new(c:AudioContext, count:Int):Void {
		super(c, c.c.createChannelMerger( count ));
	}
}
