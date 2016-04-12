package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.ListItem;

import tannus.geom.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class List <T : ListItem> extends EntityContainer {
	/* Constructor Function */
	public function new():Void {
		super();

		items = new Array();
		cacheLayout = false;
		altered = false;
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
		if (!items.has( item )) {
			items.push( item );
			addChild( item );
			item.parent = this;
			altered = true;
			if (stage != null) {
				stage.registry[item.id] = item;
				item.stage = stage;
				item.dispatch('activated', stage);
			}
			else {
				on('activated', function(stage:Stage) {
					stage.registry[item.id] = item;
					item.stage = stage;
					item.dispatch('activated', stage);
				});
			}
		}
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
		var res = items.remove( item );
		altered = true;
		return res;
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
			if (isValidChild( item )) {
				updateItem(stage, item);
				positionItem(ip, item);
			}
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
	  * List-specific update
	  * update the geometry of [this] List's items
	  */
	public function updateList(stage : Stage):Void {
		positionItems( stage );
	}

	/**
	  * update [this] List
	  */
	override public function update(stage : Stage):Void {
		if ( altered ) {
			updateList( stage );
			altered = false;
		}

		super.update( stage );
	}

/* === Instance Fields === */

	public var items : Array<T>;
	public var cacheLayout : Bool;
	
	private var altered : Bool;
}
