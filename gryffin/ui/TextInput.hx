package gryffin.ui;

import js.html.InputElement;
import js.Browser.document in doc;

import tannus.geom.*;
import tannus.dom.Element;
import tannus.math.TMath.*;
import tannus.graphics.Color;
import tannus.events.KeyboardEvent;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.fx.TimedEffect;

import Std.*;
import gryffin.Tools.defer;

using StringTools;
using tannus.ds.StringUtils;
using tannus.math.TMath;

class TextInput extends Entity {
	/* Constructor Function */
	public function new():Void {
		super();
		pos = new Point();
		box = new TextBox();
		box.padding = 0;
		fontSize = 10;

		input = doc.createInputElement();
		el = new Element( input );

		padding = new Padding();
		padding.horizontal = 3;
		padding.vertical = 3;

		borderColor = '#000';
		backgroundColor = null;
		selectionColor = '#b4daff';
		cursorColor = '#000';
		borderWidth = 1;
		borderRadius = 0;

		minWidth = 150;
		maxWidth = 250;

		_hasFocus = false;
		showCursor = false;
		offset = new Point();
		cursor = 0;
	}

/* === Instance Methods === */

	/**
	  * Initialize [this] TextInput
	  */
	override public function init(s : Stage):Void {
		super.init( s );
		input.type = 'text';
		el.css.write({
			'width': '0px',
			'height': '0px',
			'padding': '0px',
			'opacity': '0'
		});
		doc.body.appendChild( input );
		addEffect(new CursorBlinker());
		listen();
	}

	/**
	  * Listen for relevant events on the input
	  */
	private function listen():Void {
		el.on('focusin', function(e) {
			_hasFocus = true;
			dispatch('focusin', null);
		});

		el.on('focusout', function(e) {
			_hasFocus = false;
			dispatch('focusout', null);
		});

		stage.on('keydown', function(e : KeyboardEvent) {
			if ( _hasFocus ) {
				if (e.keyCode >= 37 && e.keyCode <= 40) {
					defer( updateText );
				}
				dispatch('keydown', e);
			}
		});

		el.on('input', function(e) {
			updateText();
			dispatch('input', null);
		});

		on('click', function(e) {
			if ( !_hasFocus ) {
				focus();
			}
		});
	}

	/**
	  * Delete [this] TextInput
	  */
	override public function delete():Void {
		super.delete();
		el.remove();
	}

	/**
	  * Shift focus to [this] Input
	  */
	public function focus():Void {
		input.focus();
	}

	/**
	  * Unfocus [this] input
	  */
	public function blur():Void {
		input.blur();
	}

	/**
	  * Render [this] Input
	  */
	override public function render(s:Stage, c:Ctx):Void {
		c.save();

		c.strokeStyle = '#666';
		
		// x, y offsets for the text
		var tx:Float = (x + padding.left);
		var ty:Float = (y + padding.top);


		// create box outline
		c.beginPath();
		c.strokeStyle = borderColor.toString();
		if (backgroundColor != null)
			c.fillStyle = backgroundColor.toString();
		c.lineWidth = borderWidth;
		c.roundRect(x, y, width, height, borderRadius);
		c.closePath();
		if (backgroundColor != null)
			c.fill();
		c.stroke();

		/* -- handle the cursor or the selection -- */
		if ( _hasFocus ) {
			if (selection == null) {
				if ( showCursor ) {
					// draw the cursor
					c.fillStyle = cursorColor.toString();
					c.fillRect(tx+cursor, ty, 1, box.height);
				}
			}
			else {
				// draw the selection
				var selw:Float = box.getMetrics(selection).width;
				c.fillStyle = selectionColor.toString();
				c.fillRect(tx+cursor, ty, selw, box.height);
			}
		}

		// draw the text itself
		c.drawComponent(box, 0, 0, box.width, box.height, tx, ty, box.width, box.height);

		c.restore();
	}

	/**
	  * Determine whether a Point falls within out content-rect
	  */
	override public function containsPoint(p : Point):Bool {
		return rect.containsPoint( p );
	}

	/**
	  * Update the textual content of [this] Input
	  */
	private function updateText():Void {
		var text:String = input.value;
		var size = box.getMetrics( text );
		while (size.width > maxWidth) {
			text = text.substr(0, -1);
			size = box.getMetrics( text );
		}

		if (input.value != text) {
			input.value = text;
		}
		box.text = text;

		cursor = box.getMetrics(input.value.substring(0, caret)).width;
	}

/* === Computed Instance Fields === */

	/* the computed width of [this] Input */
	public var width(get, never):Float;
	private function get_width():Float {
		return (box.textWidth + padding.horizontal).clamp(minWidth, maxWidth);
	}

	/* the computed height of [this] Input */
	public var height(get, never):Float;
	private function get_height():Float {
		return (box.textHeight + padding.vertical);
	}

	/* the x-position of [this] Input */
	public var x(get, set):Float;
	private inline function get_x():Float return pos.x;
	private inline function set_x(v : Float):Float return (pos.x = v);
	
	/* the y-position of [this] Input */
	public var y(get, set):Float;
	private inline function get_y():Float return pos.y;
	private inline function set_y(v : Float):Float return (pos.y = v);

	/* the content rectangle */
	public var rect(get, never):Rectangle;
	private function get_rect():Rectangle {
		return new Rectangle(x, y, width, height);
	}

	/* the position of the caret */
	public var caret(get, set):Int;
	private function get_caret():Int {
		return input.selectionStart;
	}
	private function set_caret(v : Int):Int {
		defer(function() {
			input.setSelectionRange(v, v);
		});
		return v;
	}

	/* the currently selected text */
	public var selection(get, never):Null<String>;
	private function get_selection():Null<String> {
		if (input.selectionStart == input.selectionEnd) {
			return null;
		}
		else {
			return input.value.substring(input.selectionStart, input.selectionEnd);
		}
	}

	/* the current value of [this] TextInput */
	public var value(get, set):String;
	private inline function get_value():String return input.value;
	private function set_value(v : String):String {
		input.value = v;
		updateText();
		caret = v.length;
		return value;
	}

	/* the text color */
	public var textColor(get, set):Color;
	private inline function get_textColor():Color return box.color;
	private inline function set_textColor(v : Color):Color return (box.color = v);

	/* the font family */
	public var fontFamily(get, set):String;
	private inline function get_fontFamily():String return box.fontFamily;
	private inline function set_fontFamily(v : String):String return (box.fontFamily = v);

	/* the font size */
	public var fontSize(get, set):Int;
	private inline function get_fontSize():Int return box.fontSize;
	private inline function set_fontSize(v : Int):Int return (box.fontSize = v);

/* === Instance Fields === */

	public var pos : Point;
	public var box : TextBox;
	public var input : InputElement;
	public var el : Element;
	public var padding : Padding;
	public var borderColor : Color;
	public var backgroundColor : Null<Color>;
	public var selectionColor : Color;
	public var cursorColor : Color;
	public var borderWidth : Float;
	public var borderRadius : Float;
	
	public var maxWidth : Float;
	public var minWidth : Float;

	private var _hasFocus : Bool;
	private var showCursor : Bool;
	private var offset : Point;
	private var cursor : Float;
}

@:access( gryffin.ui.TextInput )
private class CursorBlinker extends TimedEffect<TextInput> {
	/* Constructor Function */
	public function new():Void {
		super();
		interval = 500;
	}

	override public function affect(i : TextInput):Void {
		i.showCursor = !i.showCursor;
		super.affect( i );
	}
}
