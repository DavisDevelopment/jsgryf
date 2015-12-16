package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.ListItem;

import tannus.geom.*;

using tannus.ds.ArrayTools;
using tannus.math.TMath;

class List <T : ListItem> extends EntityContainer {
	/* Constructor Function */
	public function new():Void {
		super();

		items = new Array();
	}

/* === Instance Methods === */

	/**
	  * Get the children of [this] List
	  */
	override public function getChildren():Array<Entity> {
		return cast items;
	}

	/**
	  * Add an item to [this] List
	  */
	public function addItem(item : T):Void {
		items.push( item );
	}

	/**
	  * Update and item in [this] List
	  */
	public function updateItem(stage:Stage, item:T):Void {
		null;
	}

	/**
	  * Remove an item from [this] List
	  */
	public function removeItem(item : T):Bool {
		return items.remove( item );
	}

	/**
	  * the starting position of the items
	  */
	private function firstPos():Point {
		return new Point();
	}

	/**
	  * Position all items in [this] List
	  */
	private function positionItems(stage : Stage):Void {
		var ip:Point = firstPos();
		for (item in items) {
			updateItem(stage, item);
			positionItem(ip, item);
		}
	}

	/**
	  * mutate the position of an Item
	  */
	private function positionItem(p:Point, item:T):Void {
		var ip = item.pos;
		ip.copyFrom( p );
		p.y += item.h;
	}

	/**
	  * update [this] List
	  */
	override public function update(stage : Stage):Void {
		super.update( stage );

		positionItems( stage );
	}

/* === Instance Fields === */

	public var items : Array<T>;
}
