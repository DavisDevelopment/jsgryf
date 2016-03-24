package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.events.*;
import tannus.graphics.Color;

import Std.string in s;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class GenericButton extends Ent {
	/* Constructor Function */
	public function new(?model : Button):Void {
		super();

		box = new TextBox();
		padding = new Padding();
		border = new Border();
		hovered = false;
		centerText = false;

		fontFamily = 'Helvetica';
		textColor = new Color(255, 255, 255);
		backgroundColor = new Color(33, 153, 232);
		borderColor = backgroundColor.clone();
		borderWidth = 1;

		if (model != null) {
			text = model.text;
			on('click', model.click);
		}
	}

/* === Instance Methods === */

	/**
	  * update [this] Button
	  */
	override public function update(stage : Stage):Void {
		w = ((border.width * 2) + padding.horizontal + box.width);
		h = ((border.width * 2) + padding.vertical + box.height);

		var mp = stage.getMousePosition();
		hovered = (mp != null && containsPoint( mp ));

		if ( hovered ) {
			stage.cursor = 'pointer';
		}
	}

	/**
	  * render [this] Button
	  */
	override public function render(stage:Stage, c:Ctx):Void {
		c.save();
		/* draw the backround */
		c.beginPath();
		c.fillStyle = s(backgroundColor);
		c.drawRect( rect );
		c.closePath();
		c.fill();

		/* draw the text */
		c.drawComponent(box, 0, 0, box.width, box.height, (x + border.width + padding.left), (y + border.width + padding.top), box.width, box.height);

		/* the the border */
		if (border.width > 0) {
			c.beginPath();
			c.strokeStyle = s(border.color);
			c.lineWidth = border.width;
			if (border.radius == 0) {
				c.drawRect( rect );
			}
			else {
				c.drawRoundRect(rect, border.radius);
			}
			c.closePath();
			c.stroke();
		}
	}

/* === Computed Instance Fields === */

	public var text(get, set):String;
	private inline function get_text():String return box.text;
	private inline function set_text(v : String):String return (box.text = v);

	public var fontFamily(get, set):String;
	private inline function get_fontFamily():String return box.fontFamily;
	private inline function set_fontFamily(v : String):String return (box.fontFamily = v);

	public var fontSizeUnit(get, set):String;
	private inline function get_fontSizeUnit():String return box.fontSizeUnit;
	private inline function set_fontSizeUnit(v : String):String return (box.fontSizeUnit = v);

	public var fontSize(get, set):Int;
	private inline function get_fontSize():Int return box.fontSize;
	private inline function set_fontSize(v : Int):Int return (box.fontSize = v);

	public var textColor(get, set):Color;
	private inline function get_textColor():Color return box.color;
	private inline function set_textColor(v : Color):Color return (box.color = v);

	public var borderColor(get, set):Color;
	private inline function get_borderColor():Color return border.color;
	private inline function set_borderColor(v : Color):Color return (border.color = v);

	public var borderWidth(get, set):Float;
	private inline function get_borderWidth():Float return border.width;
	private inline function set_borderWidth(v : Float):Float return (border.width = v);

	public var borderRadius(get, set):Float;
	private inline function get_borderRadius():Float return border.radius;
	private inline function set_borderRadius(v : Float):Float return (border.radius = v);

/* === Instance Fields === */

	public var backgroundColor : Color;
	public var centerText : Bool;

	private var box : TextBox;
	public var padding : Padding;
	public var border : Border;
	private var hovered : Bool;
}
