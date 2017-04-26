package gryffin.display;

import gryffin.display.Canvas;
import gryffin.display.Ctx;
import gryffin.display.Paintable;
import gryffin.display.TextAlign;
import gryffin.display.Context.TextMetrics;

import tannus.geom.*;
import tannus.io.VoidSignal;
import tannus.graphics.Color;

import Math.*;

using StringTools;
using tannus.ds.StringUtils;
using tannus.math.TMath;

class TextBox implements Paintable {
	/* Constructor Function */
	public function new():Void {
		onStateChanged = new VoidSignal();
		onTextChanged = new VoidSignal();
		txt = '';
		multiline = false;
		wordWrap = null;
		stateChanged = true;
		canvas = new Canvas();
		padding = 0;
		fontFamily = 'Arial';
		fontSize = 12;
		fontSizeUnit = 'pt';
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
		if ( cache ) {
			c.paint(toCanvas(), s, d);
		}
		else {
			if ( multiline ) {
				measure();
				var w = round(textWidth + padding * 2);
				var h = round(textHeight + padding * 2);

				if (backgroundColor != null) {
					c.fillStyle = backgroundColor.toString();
					c.fillRect(d.x, d.y, w, h);
				}

				applyStyles( c );
				var p:Point = new Point((d.x + padding), (d.y + padding));
				for (line in lines()) {
					c.fillText(line.text, p.x, p.y);
					p.y += line.height;
				}
			}
			else {
				measure();
				// resize the canvas to fit the text
				var w = round(textWidth + padding * 2);
				var h = round(textHeight + padding * 2);

				/* draw the background, if any */
				if (backgroundColor != null) {
					c.fillStyle = backgroundColor.toString();
					c.fillRect(d.x, d.y, w, h);
				}

				/* draw the text to the canvas */
				applyStyles( c );
				c.fillText(text, (d.x + padding), (d.y + padding));
			}
		}
	}

	/**
	  * Get the metrics of the given text, with the current settings
	  */
	public function getMetrics(s : String):TextMetrics {
		applyStyles( canvas.context );
		return canvas.context.measureText( s );
	}

	/**
	  * Automatically scale the font-size to the maximum that still 
	  * draws text inside the given boundaries
	  */
	public function autoScale(?mw:Float, ?mh:Float, ?step:Float):Void {
	    if (step == null) {
	        step = 1.0;
	    }

		/* if neither [mw] nor [mh] are provided, do nothing */
		if (mw == null && mh == null) {
			return ;
		}
		else {
			fontSize = 1.0;

			while ( true ) {
				measure();
				
				/* if the max-width was provided, and has been exceeded */
				if (mw != null && width > mw) {
					break;
				}

				/* if the max-height was provided, and has been exceeded */
				if (mh != null && height > mh) {
					break;
				}

				/* if neither boundary has been exceeded, increase [fontSize] by one */
				fontSize += step;
			}

			/*
			   if the loop has terminated, then the last
			   time [fontSize] was incremented, it 
			   exceeded one or more of the boundaries,
			   so we'll just decrement [fontSize] by one,
			   and that's the result
			*/
			fontSize -= step;
		}
	}

	/**
	  * Fit [this] text to the given metrics
	  */
	public function fit(?w:Float, ?h:Float):Void {
		if (w == null && h == null) {
			return ;
		}
		else {
			while ( true ) {
				measure();

				if (w != null && width > w) {
					fontSize--;
				}

				else if (h != null && height > h) {
					fontSize--;
				}

				else {
					break;
				}
			}
		}
	}

	/**
	  * word wrap
	  */
	public function wrappedLines():Array<String> {
		var lineWidth:Float = wordWrap;
		var s = text.macbyteMap(_.isLineBreaking() ? 32 : _);
		var allwords = s.split(' ');
		var lines:Array<String> = new Array();
		var line:Array<String> = new Array();

		for (w in allwords) {
			var testLine = line.concat([w]).join(' ');
			var metrics = getMetrics( testLine );
			if (metrics.width > lineWidth) {
				lines.push(line.join(' '));
				line = [w];
			}
			else {
				line.push( w );
			}
		}

		return lines;
	}

	/**
	  * Draw [this] TextBox to a Canvas
	  */
	private function toCanvas():Canvas {
		if ( stateChanged ) {
			stateChanged = false;

			if ( multiline ) {
				measure();
				canvas.resize(round(textWidth + padding*2), round(textHeight + padding*2));
				var c:Ctx = canvas.context;

				if (backgroundColor != null) {
					c.fillStyle = backgroundColor.toString();
					c.fillRect(0, 0, canvas.width, canvas.height);
				}

				applyStyles( canvas.context );
				var p:Point = new Point(padding, padding);
				for (line in lines()) {
					c.fillText(line.text, p.x, p.y);
					p.y += line.height;
				}
			}
			else {
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
				canvas.context.fillText(text, padding, padding);
			}
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
		c.textBaseline = 'top';
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
		bits.push( '${fontSize}${fontSizeUnit}' );
		bits.push( fontFamily );
		return bits.join(' ');
	}

	/**
	  * Measure the size of [text] when rendered with the current styles
	  */
	private function measure():Void {
		if ( multiline ) {
			_textWidth = 0;
			_textHeight = 0;
			for (l in lines()) {
				_textWidth = max(_textWidth, l.width);
				_textHeight += l.height;
			}
		}
		else {
			applyStyles( canvas.context );
			var size = canvas.context.measureText( text );
			_textWidth = size.width;
			_textHeight = (size.height);
		}
	}

	/**
	  * get an Array of individual lines of text to be rendered
	  */
	private function lines():Array<TextLine> {
		multiline = false;
		var slines:Array<String> = (wordWrap != null ? wrappedLines() : text.split('\n'));
		var lines = new Array();
		for (s in slines) {
			var m = getMetrics( s );
			lines.push({
				'text'  : s,
				'width' : m.width,
				'height': m.height
			});
		}
		multiline = true;
		return lines;
	}

	/**
	  * query whether [this] TextBox's state has changed
	  */
	public inline function hasStateChanged():Bool return stateChanged;

	/**
	  * report a change in [this] TextBox's state
	  */
	private function changed():Void {
		stateChanged = true;
		onStateChanged.fire();
	}

/* === Computed Instance Fields === */

	/* the textual content of [this] TextBox */
	public var text(get, set):String;
	private function get_text():String return txt;
	private function set_text(v : String):String {
		if (v != txt) {
			changed();
			onTextChanged.fire();
		}
		return (txt = v);
	}

	/* the padding inside [this] TextBox */
	public var padding(get, set):Float;
	private function get_padding():Float return _padding;
	private function set_padding(v : Float):Float {
		if (v != _padding) {
			changed();
		}
		return (_padding = v);
	}

	/* font family */
	public var fontFamily(get, set):String;
	private function get_fontFamily():String return _fontFamily;
	private function set_fontFamily(v : String):String {
		if (v != _fontFamily) {
			changed();
		}
		if (v.has(' '))
			v = v.wrap('"');
		return (_fontFamily = v);
	}

	/* font size */
	public var fontSize(get, set):Float;
	private function get_fontSize():Float return _fontSize;
	private function set_fontSize(v : Float):Float {
		if (v != _fontSize) {
			changed();
		}
		return (_fontSize = v);
	}

	/* font size unit */
	public var fontSizeUnit(get, set):String;
	private function get_fontSizeUnit():String {
		return _fontSizeUnit;
	}
	private function set_fontSizeUnit(v : String):String {
		if (v != _fontSizeUnit) {
			changed();
		}
		return (_fontSizeUnit = v);
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
			changed();
		}
		return (_color = v);
	}

	/* the background Color of the rendered text */
	public var backgroundColor(get, set):Null<Color>;
	private function get_backgroundColor():Null<Color> return _backgroundColor;
	private function set_backgroundColor(v : Null<Color>):Null<Color> {
		if (v != _backgroundColor) {
			changed();
		}
		return (_backgroundColor = v);
	}

	/* the alignment of [this] Text */
	public var align(get, set):TextAlign;
	private function get_align():TextAlign return _align;
	private function set_align(v : TextAlign):TextAlign {
		if (v != _align) {
			changed();
		}
		return (_align = v);
	}

	/* whether [this] text is bold */
	public var bold(get, set):Bool;
	private function get_bold():Bool return _bold;
	private function set_bold(v : Bool):Bool {
		if (v != _bold) {
			changed();
		}
		return (_bold = v);
	}

	/* whether [this] text is italic */
	public var italic(get, set):Bool;
	private function get_italic():Bool return _italic;
	private function set_italic(v : Bool):Bool {
		if (v != _italic) {
			changed();
		}
		return (_italic = v);
	}

/* === Instance Fields === */

	private var txt:String;
	private var stateChanged:Bool;
	private var canvas:Canvas;
	private var _padding:Float;
	private var _fontFamily:String;
	private var _fontSize:Float;
	private var _fontSizeUnit:String;
	private var _color:Color;
	private var _backgroundColor:Null<Color>;
	private var _align:TextAlign;
	private var _bold:Bool;
	private var _italic:Bool;
	public var multiline:Bool;
	public var wordWrap:Null<Float>;
	public var cache:Bool = true;
	public var onStateChanged:VoidSignal;
	public var onTextChanged:VoidSignal;

	private var _textWidth:Float;
	private var _textHeight:Float;
}

typedef TextLine = {
	var text : String;
	var width : Float;
	var height : Float;
};
