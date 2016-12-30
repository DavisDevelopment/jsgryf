package gryffin.display;

import tannus.geom.*;

import gryffin.Tools.*;

class Animation implements Paintable {
	/* Constructor Function */
	public function new(?delay:Float, ?frames:Array<Paintable>, loop:Bool=false, autoIncrement:Bool=true):Void {
		this.loop = loop;
		this.autoIncrement = autoIncrement;
		this.frameDuration = 1000;
		if (frameDuration != null)
			this.frameDuration = delay;
		this.frames = new Frames( frames );
		this.lastFrame = null;
	}

/* === Instance Methods === */

	/**
	  * Paint [this]
	  */
	public function paint(c:Ctx, s:Rectangle, d:Rectangle):Void {
		frames.paint(c, s, d);

		var time = now;
		if (lastFrame == null || (time - lastFrame) >= frameDuration) {
			next();
		}
	}

	/**
	  * Jump to the next frame
	  */
	public function next():Void {
		if (frames.frameIndex == (frames.length - 1)) {
			if ( loop ) {
				frames.frameIndex = 0;
			}
			else {
				null;
			}
			lastFrame = now;
		}
		else {
			frames.frameIndex++;
			lastFrame = now;
		}
	}

/* === Instance Fields === */

	public var frameDuration : Float;
	public var frames : Frames;
	public var loop : Bool;
	public var autoIncrement : Bool;

	private var lastFrame : Float;
}
