package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;
import tannus.graphics.Color;

import Math.*;
import tannus.math.TMath.*;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class LayoutStyles {
	/* Constructor Function */
	public function new(e : LayoutElement):Void {
		element = e;

		display = Inline;
		margin = new Padding();
		padding = new Padding();
		border = new Border(0, null, null);
		font = new FontStyles();

		backgroundColor = null;
		color = new Color(0, 0, 0);
	}

/* === Instance Fields === */

	/* == Layout Fields == */
	public var display : LayoutDisplay;
	public var margin : Padding;
	public var padding : Padding;
	public var border : Border;
	public var font : FontStyles;
	
	/* == Color Fields == */
	public var backgroundColor : Null<Color>;
	public var color : Null<Color>;

	private var element : LayoutElement;
}

@:enum
abstract LayoutDisplay (String) from String to String {
	var None = 'none';
	var Block = 'block';
	var Inline = 'inline';
}
