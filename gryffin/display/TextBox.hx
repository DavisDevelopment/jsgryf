package gryffin.display;

import gryffin.display.Canvas;
import gryffin.display.Ctx;
import gryffin.display.Paintable;
import gryffin.display.TextAlign;

import tannus.geom.*;
import tannus.graphics.Color;

import Math.*;

using StringTools;
using tannus.ds.StringUtils;
using tannus.math.TMath;

class TextBox implements Paintable {
	/* Constructor Function */
	public function new():Void {
		txt = '';
		stateChanged = true;
		canvas = new Canvas();
		padding = 0;
		fontFamily = 'Arial';
		fontSize = 12;
		_color = new Color(0, 0, 0);
		_backgroundColor = null;
		_align = Start;
		_bold = false;
		_italic = false;
	}

/* === Instance Methods === */

	/**
	  * Paint [this] TextBox to a Canvas
	  */
	public function paint(c:Ctx, s:Rectangle, d:Rectangle):Void {
		c.paint(toCanvas(), s, d);
	}

	/**
	  * Draw [this] TextBox to a Canvas
	  */
	private function toCanvas():Canvas {
		if ( stateChanged ) {
			stateChanged = false;

			measure();
			// resize the canvas to fit the text
			canvas.resize(round(textWidth + padding*2), round(textHeight + padding*2));
			var c:Ctx = canvas.context;

			/* draw the background, if any */
			if (backgroundColor != null) {
				c.fillStyle = backgroundColor.toString();
				c.fillRect(0, 0, canvas.width, canvas.height);
			}

			/* draw the text to the canvas */
			applyStyles( canvas.context );
			canvas.context.fillText(text, padding, padding + textHeight);
		}

		return canvas;
	}

	/**
	  * Apply the current styling to the given Ctx
	  */
	private function applyStyles(c : Ctx):Void {
		c.font = fontString();
		c.textAlign = align;
		c.fillStyle = color.toString();
	}

	/**
	  * Get the current font styling as a String
	  */
	private function fontString():String {
		var bits:Array<String> = new Array();
		if ( bold )
			bits.push('bold');
		if ( italic )
			bits.push('italic');
		bits.push( '${fontSize}pt' );
		bits.push( fontFamily );
		return bits.join(' ');
	}

	/**
	  * Measure the size of [text] when rendered with the current styles
	  */
	private function measure():Void {
		applyStyles( canvas.context );
		var size = canvas.context.measureText( text );
		_textWidth = size.width;
		_textHeight = size.height;
	}

/* === Computed Instance Fields === */

	/* the textual content of [this] TextBox */
	public var text(get, set):String;
	private function get_text():String return txt;
	private function set_text(v : String):String {
		if (v != txt) {
			stateChanged = true;
		}
		return (txt = v);
	}

	/* the padding inside [this] TextBox */
	public var padding(get, set):Float;
	private function get_padding():Float return _padding;
	private function set_padding(v : Float):Float {
		if (v != _padding) {
			stateChanged = true;
		}
		return (_padding = v);
	}

	/* font family */
	public var fontFamily(get, set):String;
	private function get_fontFamily():String return _fontFamily;
	private function set_fontFamily(v : String):String {
		if (v != _fontFamily) {
			stateChanged = true;
		}
		return (_fontFamily = v);
	}

	/* font size */
	public var fontSize(get, set):Int;
	private function get_fontSize():Int return _fontSize;
	private function set_fontSize(v : Int):Int {
		if (v != _fontSize) {
			stateChanged = true;
		}
		return (_fontSize = v);
	}

	/* the width of the rendered text */
	public var textWidth(get, never):Float;
	private function get_textWidth():Float {
		if ( stateChanged ) {
			measure();
		}
		return _textWidth;
	}

	/* the height of the rendered text */
	public var textHeight(get, never):Float;
	private function get_textHeight():Float {
		if ( stateChanged ) {
			measure();
		}
		return _textHeight;
	}

	/* the total width of [this] */
	public var width(get, never):Float;
	private function get_width():Float {
		return ((padding * 2) + textWidth);
	}

	/* the total height of [this] */
	public var height(get, never):Float;
	private function get_height():Float {
		return ((padding * 2) + textHeight);
	}

	/* the Color of the rendered text */
	public var color(get, set):Color;
	private function get_color():Color return _color;
	private function set_color(v : Color):Color {
		if (v != _color) {
			stateChanged = true;
		}
		return (_color = v);
	}

	/* the background Color of the rendered text */
	public var backgroundColor(get, set):Null<Color>;
	private function get_backgroundColor():Null<Color> return _backgroundColor;
	private function set_backgroundColor(v : Null<Color>):Null<Color> {
		if (v != _backgroundColor) {
			stateChanged = true;
		}
		return (_backgroundColor = v);
	}

	/* the alignment of [this] Text */
	public var align(get, set):TextAlign;
	private function get_align():TextAlign return _align;
	private function set_align(v : TextAlign):TextAlign {
		if (v != _align) {
			stateChanged = true;
		}
		return (_align = v);
	}

	/* whether [this] text is bold */
	public var bold(get, set):Bool;
	private function get_bold():Bool return _bold;
	private function set_bold(v : Bool):Bool {
		if (v != _bold) {
			stateChanged = true;
		}
		return (_bold = v);
	}

	/* whether [this] text is italic */
	public var italic(get, set):Bool;
	private function get_italic():Bool return _italic;
	private function set_italic(v : Bool):Bool {
		if (v != _italic) {
			stateChanged = true;
		}
		return (_italic = v);
	}

/* === Instance Fields === */

	private var txt:String;
	private var stateChanged:Bool;
	private var canvas:Canvas;
	private var _padding:Float;
	private var _fontFamily:String;
	private var _fontSize:Int;
	private var _color:Color;
	private var _backgroundColor:Null<Color>;
	private var _align:TextAlign;
	private var _bold:Bool;
	private var _italic:Bool;

	private var _textWidth:Float;
	private var _textHeight:Float;
}
