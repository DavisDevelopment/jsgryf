package gryffin.display;

import tannus.geom.*;

class Frames implements Paintable {
	/* Constructor Function */
	public function new(?frames : Array<Paintable>):Void {
		this.frames = (frames != null ? frames : []);
		this.frameIndex = 0;
	}

/* === Instance Methods === */

	/**
	  * Render [this]
	  */
	public function paint(c:Ctx, src:Rectangle, dest:Rectangle):Void {
		var o = frames[frameIndex];
		if (o == null) {
			throw 'Error: Frame cannot be null';
		}
		else {
			c.paint(o, src, dest);
		}
	}

/* === Computed Instance Fields === */

	// the index of the frame to render
	public var frameIndex(default, set):Int;
	private function set_frameIndex(value : Int):Int {
		return (frameIndex = value);
	}

	public var length(get, never):Int;
	private inline function get_length():Int return frames.length;

/* === Instance Fields === */

	private var frames : Array<Paintable>;
}
