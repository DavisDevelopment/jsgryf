package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;

import Math.*;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class Panel extends LayoutElement {
	/* Constructor Function */
	public function new():Void {
		super();
	}

/* === Instance Methods === */

	/**
	  * render [this] Panel
	  */
	override public function render(stage:Stage, c:Ctx):Void {
		var gr = getGlobalRectangle();

		/* draw the background */
		if (styles.backgroundColor != null) {
			c.fillStyle = styles.backgroundColor.toString();
			c.beginPath();
			c.drawRoundRect(gr, styles.border.radius);
			c.closePath();
			c.fill();
		}

		/* draw the content of [this] Panel */
		renderContent(stage, c, gr);

		/* draw the border */
		if (styles.border.width != 0) {
			c.save();
			c.strokeStyle = styles.border.color.toString();
			c.lineWidth = styles.border.width;
			c.beginPath();
			c.drawRoundRect(gr, styles.border.radius);
			c.closePath();
			c.stroke();
			c.restore();
		}
	}

	/**
	  * draw the content of [this] Pane
	  */
	public function renderContent(stage:Stage, c:Ctx, r:Rectangle):Void {
		super.render(stage, c);
	}

/* === Instance Fields === */
}
