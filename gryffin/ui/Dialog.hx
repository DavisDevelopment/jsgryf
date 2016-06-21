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

class Dialog extends Panel {
	/* Constructor Function */
	public function new():Void {
		super();

		styles.backgroundColor = new Color(255, 255, 255);

		opened = false;
	}

/* === Instance Methods === */

	/**
	  * When [this] Dialog box is activated, hide/cache it until it is explicitly opened
	  */
	override public function init(stage : Stage):Void {
		super.init( stage );

		cache();
		hide();

		var otherDialogs:Array<Dialog> = stage.get('~gryffin.ui.Dialog:opened[id != "$id"]').selected;
		for (d in otherDialogs) {
			d.delete();
		}
	}

	/**
	  * Open [this] Dialog
	  */
	public function open():Void {
		opened = true;
		uncache();
		show();
	}

	/**
	  * Close [this] Dialog
	  */
	public function close():Void {
		opened = false;
		cache();
		hide();
	}

	/**
	  * Update [this] Dialog
	  */
	override public function update(stage : Stage):Void {
		super.update( stage );

		/* make sure that [this] Dialog box is always on top */
		var higherPriority:Array<Entity> = stage.get('[priority > $priority]').selected;
		var isChild:Entity->Bool = (parent == null ? stage.hasChild : parent.hasChild);
		higherPriority = higherPriority.macfilter(isChild(_));
		if (!higherPriority.empty()) {
			var maxPriority:Int = higherPriority.macmax( _.priority ).priority;
			priority = (maxPriority + 1);
		}
	}

/* === Instance Fields === */

	private var opened : Bool;
}
