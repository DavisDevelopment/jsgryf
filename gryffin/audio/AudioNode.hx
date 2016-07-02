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

import js.html.audio.AudioNode in NNode;
import js.html.audio.AudioContext in NCtx;

using tannus.math.TMath;

class AudioNode<T:NNode> {
	/* Constructor Function */
	public function new(c:AudioContext, n:T):Void {
		ctx = c;
		node = n;
	}

/* === Instance Methods === */

	/**
	  * Connect one output of [this] node to one input of [other]
	  */
	public function connect<T:NNode>(other : AudioNode<T>):Void {
		node.connect( other.node );
	}

/* === Computed Instance Fields === */

/* === Instance Fields === */

	public var ctx : AudioContext;
	public var node : T;
}
