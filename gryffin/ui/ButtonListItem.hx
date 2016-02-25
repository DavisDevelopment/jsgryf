package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.ListItem;
import gryffin.ui.Padding;
import gryffin.ui.ContextMenu;
import gryffin.ui.Button;

import tannus.geom.*;
import tannus.graphics.Color;
import tannus.events.MouseEvent;

import Std.*;
import Math.*;
import tannus.math.TMath.*;

class ButtonListItem extends ListItem {
	/* Constructor Function */
	public function new(btn : Button):Void {
		super();

		button = btn;
		box = new TextBox();
		hovered = false;

		padding = new Padding();
		margin = new Padding();
		textColor = '#000';
		backgroundColor = '#FFF';
		borderColor = '#000';
		borderWidth = 1;
		borderRadius = 0;
		fontFamily = 'Verdana';
		fontSize = 10;

		on('click', onClick);
	}

/* === Instance Methods === */

	/**
	  * Update [this]
	  */
	override public function update(stage : Stage):Void {
		super.update( stage );

		box.text = button.text;
		box.color = textColor;
		box.fontFamily = fontFamily;
		box.fontSize = fontSize;
		var ir = innerRect;
		w = ir.w;
		h = ir.h;

		var mp = stage.getMousePosition();
		hovered = false;
		if (mp != null && containsPoint( mp )) {
			hovered = true;
		}

		if ( hovered ) {
			stage.cursor = 'pointer';
		}
	}

	/**
	  * Render [this]
	  */
	override public function render(s:Stage, c:Ctx):Void {
		super.render(s, c);

		box.color = textColor;

		var ir = innerRect;
		c.save();
		c.beginPath();
		c.fillStyle = string( backgroundColor );
		c.strokeStyle = string( borderColor );
		c.lineWidth = borderWidth;
		if (borderRadius <= 0) {
			c.drawRect( ir );
		}
		else {
			c.roundRect(ir.x, ir.y, ir.w, ir.h, borderRadius);
		}
		c.closePath();
		c.fill();
		c.stroke();
		c.restore();

		c.drawComponent(box, 0, 0, box.width, box.height, (x + padding.left), (y + padding.top), box.width, box.height);
	}

	/**
	  * test whether the given Point is inside the content rectangle of [this]
	  */
	override public function containsPoint(p : Point):Bool {
		return innerRect.containsPoint( p );
	}

	/**
	  * handle the 'click' event
	  */
	public function onClick(event : MouseEvent):Void {
		button.click( event );
	}

/* === Computed Instance Fields === */

	/* the inner rectangle of [this] Button */
	public var innerRect(get, never):Rectangle;
	private inline function get_innerRect():Rectangle {
		return new Rectangle(x, y, (box.width + padding.horizontal), (box.height + padding.vertical));
	}

/* === Instance Fields === */

	public var padding : Padding;
	public var margin : Padding;
	public var textColor : Color;
	public var fontFamily : String;
	public var fontSize : Int;
	public var backgroundColor : Color;
	public var borderColor : Color;
	public var borderWidth : Float;
	public var borderRadius : Float;

	private var button : Button;
	private var box : TextBox;
	private var hovered : Bool;
}
