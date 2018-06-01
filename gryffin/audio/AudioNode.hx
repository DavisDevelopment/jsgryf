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
import js.html.audio.ChannelCountMode;
import js.html.audio.ChannelInterpretation;

using tannus.math.TMath;
using tannus.ds.ArrayTools;

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
	public function connect<T:NNode>(other:AudioNode<T>, ?rest:Array<Dynamic>):Void {
		var n = conode();
		Reflect.callMethod(n, n.connect, [untyped other.conode()].concat(rest != null ? rest : []));
	}

	/**
	  * Disconnect [this] Node from a Node that it is currently connected to
	  */
	public function disconnect<T:NNode>(?destination:AudioNode<NNode>, ?output:Int, ?input:Int):Void {
		var n = conode();
		var params:Array<Dynamic> = (untyped [destination, output, input]).compact();
		//if (destination != null)
			//params.push(destination.conode());
		//if (output != null)
			//params.push( output );
		//if (input != null)
			//params.push( input );
		Reflect.callMethod(n, n.disconnect, params);
	}

	/**
	  * CoNode -- Co(nnection )Node
	  * used to retrieve the NNode instance used in 'connect' and 'disconnect' calls
	  */
	private function conode():T return node;

/* === Computed Instance Fields === */

	public var numberOfInputs(get, never):Int;
	private inline function get_numberOfInputs():Int return node.numberOfInputs;

	public var numberOfOutputs(get, never):Int;
	private inline function get_numberOfOutputs():Int return node.numberOfOutputs;

	public var channelCount(get, never): Int;
	private inline function get_channelCount() return node.channelCount;

	public var channelCountMode(get, never): ChannelCountMode;
	private inline function get_channelCountMode() return node.channelCountMode;

	public var channelInterpretation(get, never): ChannelInterpretation;
	private inline function get_channelInterpretation() return node.channelInterpretation;

/* === Instance Fields === */

	public var ctx : AudioContext;
	public var node : T;
}
