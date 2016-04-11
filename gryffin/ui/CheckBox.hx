package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;
import tannus.graphics.Color;
import tannus.events.*;

class CheckBox extends Ent {
	/* Constructor Function */
	public function new():Void {
		super();

		w = h = 20;
		border = new Border();
		checked = false;
		backgroundColor = new Color(255, 255, 255);
		checkColor = new Color(0, 0, 0);
		hovered = false;

		on('click', _click);
	}

/* === Instance Methods === */

	/**
	  * update [this] CheckBox
	  */
	override public function update(stage : Stage):Void {
		super.update( stage );

		var mp = stage.getMousePosition();
		hovered = (mp != null && containsPoint( mp ));

		if ( hovered ) {
			stage.cursor = 'pointer';
		}
	}

	/**
	  * render [this] CheckBox
	  */
	override public function render(stage:Stage, c:Ctx):Void {
		c.save();
		/* draw the background */
		c.beginPath();
		c.fillStyle = backgroundColor.toString();
		c.strokeStyle = border.color.toString();
		c.lineWidth = border.width;
		if (border.radius == 0) {
			c.drawRect( rect );
		}
		else {
			c.drawRoundRect(rect, border.radius);
		}
		c.closePath();
		c.fill();
		c.stroke();

		/* draw the check mark */
		if ( checked ) {
			c.beginPath();
			c.lineWidth = 4;
			c.strokeStyle = checkColor.toString();
			c.moveTo((x + (w * 0.1)), (y + (h * 0.65)));
			c.lineTo((x + (w * 0.45)), (y + h - (h * 0.2)));
			c.lineTo((x + (w * 0.95)), (y + (h * 0.12)));
			c.stroke();
		}
		c.restore();
	}

	/**
	  * handle click events
	  */
	private function _click(event : MouseEvent):Void {
		checked = !checked;
	}

/* === Instance Fields === */

	public var checked : Bool;
	public var border : Border;
	public var backgroundColor : Color;
	public var checkColor : Color;
	public var hovered : Bool;
}
