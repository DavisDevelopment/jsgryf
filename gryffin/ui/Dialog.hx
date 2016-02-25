package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;
import tannus.events.MouseEvent;
import tannus.graphics.Color;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class Dialog extends EntityContainer {
	/* Constructor Function */
	public function new():Void {
		super();

		pos = new Point();

		titleBox = new TextBox();
		contentBox = new TextBox();

		padding = new Padding();
		textColor = '#000';
		borderColor = '#000';
		backgroundColor = '#FFF';
		borderWidth = 1;
		borderRadius = 0;
		fontFamily = 'Verdana';
		titleSize = 24;
		contentSize = 10;

		buttonMargin = new Padding();
		buttonPadding = new Padding();
		buttonFontSize = 10;

		buttons = new ButtonList();
		addChild( buttons );

		initBoxes();
	}

/* === Instance Fields === */

	/**
	  * add a Button to [this] Dialog
	  */
	public function button(text:String, onclick:MouseEvent->Void):ButtonListItem {
		return addButton({
			'text': text,
		        'click': onclick
		});
	}

	/**
	  * add a Button to [this] Dialog
	  */
	public function addButton(button : Button):ButtonListItem {
		var li = buttons.addButton( button );
		styleButton( li );
		return li;
	}

	/**
	  * apply styles to the given ButtonListItem
	  */
	private inline function styleButton(b : ButtonListItem):Void {
		b.margin.copyFrom( buttonMargin );
		b.padding.copyFrom( buttonPadding );
		b.fontSize = buttonFontSize;
	}

	/**
	  * Update [this] Dialog
	  */
	override public function update(stage : Stage):Void {
		buttons.target = getButtonsTarget();

		var tb = titleBox;
		var cb = contentBox;
		tb.fontSize = titleSize;
		cb.fontSize = contentSize;
		cb.color = tb.color = textColor;

		super.update( stage );

		var higherPriority:Array<Entity> = stage.get('[priority > $priority]').selected;
		var isChild:Entity->Bool = (parent == null ? stage.hasChild : parent.hasChild);
		higherPriority = higherPriority.macfilter(isChild(_));
		if (!higherPriority.empty()) {
			var maxPriority:Int = higherPriority.macmax( _.priority ).priority;
			priority = (maxPriority + 1);
		}
	}

	/**
	  * Render [this] Dialog
	  */
	override public function render(s:Stage, c:Ctx):Void {
		drawBox(s, c);

		var tb = titleBox;
		var cb = contentBox;
		c.drawComponent(tb, 0, 0, tb.width, tb.height, (x + padding.left), (padding.top + y + 20), tb.width, tb.height);
		c.drawComponent(cb, 0, 0, cb.width, cb.height, (x + padding.left), (padding.top + y + 20 + tb.height + 30), cb.width, cb.height);

		super.render(s, c);
	}

	/**
	  * draw the box itself
	  */
	private function drawBox(s:Stage, c:Ctx):Void {
		c.save();
		c.beginPath();
		c.fillStyle = string( backgroundColor );
		c.strokeStyle = string( borderColor );
		c.lineWidth = borderWidth;
		if (borderRadius <= 0) {
			c.drawRect( rect );
		}
		else {
			c.drawRoundRect(rect, borderRadius);
		}
		c.closePath();
		c.fill();
		c.stroke();
		c.restore();
	}

	/**
	  * get the 'target' property of [buttons]
	  */
	private function getButtonsTarget():Point {
		var p:Point = pos.clone();
		p.x = (center.x - (buttons.width / 2));
		p.y += 20;
		p.y += titleBox.height;
		p.y += 30;
		p.y += contentBox.height;
		p.y += 20;
		return p;
	}

	/**
	  * initialize the text-boxes
	  */
	private inline function initBoxes():Void {
		var tb = titleBox;
		var cb = contentBox;

		tb.fontSize = 24;
		cb.fontSize = 10;
		cb.multiline = true;
	}

	/**
	  * check whether the given Point is inside of [this] Dialog
	  */
	override public function containsPoint(p : Point):Bool {
		return rect.containsPoint( p );
	}

/* === Computed Instance Fields === */

	/* the title of [this] Dialog */
	public var title(get, set):String;
	private inline function get_title():String return titleBox.text;
	private inline function set_title(v : String):String return (titleBox.text = v);

	/* the content of [this] Dialog */
	public var content(get, set):String;
	private inline function get_content():String return contentBox.text;
	private inline function set_content(v : String):String return (contentBox.text = v);
	
	/* the 'x' position of [this] */
	public var x(get, set):Float;
	private function get_x():Float return pos.x;
	private function set_x(v : Float):Float return (pos.x = v);
	
	/* the 'y' position of [this] */
	public var y(get, set):Float;
	private function get_y():Float return pos.y;
	private function set_y(v : Float):Float return (pos.y = v);
	
	/* the width of [this] */
	public var w(get, never):Float;
	private function get_w():Float {
		var bw:Float = [titleBox.width, contentBox.width, buttons.width].max(function(v) return v);
		return (bw + padding.horizontal);
	}
	
	/* the height of [this] */
	public var h(get, never):Float;
	private function get_h():Float {
		return (
			(20 + titleBox.height) +
			(30 + contentBox.height) +
			(30 + buttons.height) +
			( padding.vertical )
		);
	}

	/* the content rect of [this] */
	public var rect(get, never):Rectangle;
	private inline function get_rect():Rectangle {
		return new Rectangle(x, y, w, h);
	}

	/* the center of [this] */
	public var center(get, set):Point;
	private inline function get_center():Point {
		return new Point((x + (w / 2)), (y + (h / 2)));
	}
	private inline function set_center(v : Point):Point {
		x = (v.x - (w / 2));
		y = (v.y - (h / 2));
		return center;
	}

	/* the number of buttons per row */
	public var buttonsPerRow(get, set):Int;
	private inline function get_buttonsPerRow():Int return buttons.cols;
	private inline function set_buttonsPerRow(v : Int):Int return (buttons.cols = v);

/* === Instance Fields === */

	public var pos : Point;
	public var buttons : ButtonList;

	public var titleBox : TextBox;
	public var contentBox : TextBox;

	public var textColor : Color;
	public var backgroundColor : Color;
	public var borderColor : Color;
	public var borderWidth : Float;
	public var borderRadius : Float;
	public var fontFamily : String;
	public var titleSize : Int;
	public var contentSize : Int;
	public var padding : Padding;

	public var buttonMargin : Padding;
	public var buttonPadding : Padding;
	public var buttonFontSize : Int;
}
