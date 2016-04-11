package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;
import tannus.math.Percent;
import tannus.graphics.Color;

class ProgressBar extends Ent {
	/* Constructor Function */
	public function new():Void {
		super();

		border = new Border();
		box = new TextBox();
		backgroundColor = new Color(255, 255, 255);
		barColor = new Color(0, 0, 0);
		prog = 0;
	}

/* === Instance Methods === */

	/**
	  * update [this] Progress bar
	  */
	override public function update(stage : Stage):Void {
		super.update( stage );
		
		box.fit(w, h);
	}

	/**
	  * render [this] Progress bar
	  */
	override public function render(stage:Stage, c:Ctx):Void {
		/* draw the background */
		c.beginPath();
		c.fillStyle = backgroundColor.toString();
		if (border.radius == 0) {
			c.drawRect( rect );
		}
		else {
			c.drawRoundRect(rect, border.radius);
		}
		c.closePath();
		c.fill();

		/* draw the bar itself */
		var bar = new Rectangle(x, y, progress.of( w ), h);
		c.beginPath();
		c.fillStyle = barColor.toString();
		if (border.radius == 0) {
			c.drawRect( bar );
		}
		else {
			c.drawRoundRect(bar, border.radius);
		}
		c.closePath();
		c.fill();

		/* draw the border */
		c.beginPath();
		c.strokeStyle = border.color.toString();
		c.lineWidth = border.width;
		if (border.radius == 0) {
			c.drawRect( rect );
		}
		else {
			c.drawRoundRect(rect, border.radius);
		}
		c.closePath();
		c.stroke();

		/* draw the text (if any) */
		if (text != '') {
			var tx:Float = 8;
			var ty:Float = (y + ((h - box.height) / 2));
			c.drawComponent(box, 0, 0, box.width, box.height, (x + tx), ty, box.width, box.height);
		}
	}

/* === Computed Instance Fields === */

	/* the text to display */
	public var text(get, set):String;
	private inline function get_text():String return box.text;
	private inline function set_text(v : String):String return (box.text = v);

	/* the progress to display */
	public var progress(get, set):Percent;
	private inline function get_progress():Percent return prog;
	private inline function set_progress(v : Percent):Percent {
		return (prog = v);
	}

/* === Instance Fields === */

	public var border : Border;
	public var box : TextBox;
	public var backgroundColor : Color;
	public var barColor : Color;

	private var prog : Percent;
}
