package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.ds.Object;
import tannus.events.MouseEvent;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;

class MenuItem extends EventDispatcher {
	/* Constructor Function */
	public function new():Void {
		super();

		rect = new Rectangle();
		parent = null;
		items = new Array();
		showChildren = false;
		eventsBound = false;
		tooltip = null;
		enabled = true;
		hovered = false;

		box = new TextBox();
		box.fontSize = 11;
		box.fontFamily = 'Ubuntu';
		box.color = '#FFF';

		padding = new Padding();
		padding.horizontal = 5;
		padding.vertical = 5;
	}

/* === Instance Methods === */

	/**
	  * Render [this] MenuItem
	  */
	public function render(s:Stage, c:Ctx):Void {
		// draw the background
		if (rootLevel && hovered) {
			c.fillStyle = '#f17746';
			c.fillRect(x-padding.left, y, w+padding.right, h);
		}

		if (subMenu && showChildren) {
			for (item in items) {
				item.render(s, c);
			}
		}

		if ( child ) {
			c.fillStyle = (hovered ? '#f17746' : root.backgroundColor.toString());
			c.fillRect(x, y, parent.panelWidth, h);
		}

		// draw the label
		c.drawComponent(box, 0, 0, box.width, box.height, (child ? x+15 : x), y, box.width, box.height);
	}

	/**
	  * Update [this] MenuItem
	  */
	public function update(stage : Stage):Void {
		if ( !eventsBound ) {
			listen( stage );
			eventsBound = true;
		}
		var mouse =  stage.getMousePosition();
		var crect = new Rectangle(x, y, (child?parent.panelWidth:w), h);
		if (mouse != null)
			hovered = crect.containsPoint(mouse);
		if ( hovered ) {
			stage.cursor = 'pointer';
		}

		if (subMenu && showChildren) {
			positionItems( stage );
		}

		if ( !rootLevel ) {
			h = box.height;
			if ( !subMenu ) {
				null;
			}
		}
	}

	/**
	  * Position [this] item's children
	  */
	private function positionItems(s : Stage):Void {
		var iy:Float = 0;
		for (item in items) {
			item.update( s );
			panelWidth = max(panelWidth, item.box.width + 30);

			if (subMenu && child) {
				if (item.index > 0)
					iy += item.padding.top;
				item.y = (y + iy);
				item.x = (x + w + padding.right + item.padding.left);
				iy += item.padding.bottom;
			}
			else {
				item.y = (root.y + root.h + iy);
				item.x = x;
				iy += item.h;
			}
		}
		//panelWidth += 30;
	}

	/**
	  * When [this] MenuItem gets clicked on
	  */
	public function click(e : MouseEvent):Void {
		dispatch('click', e);
		showChildren = !showChildren;
		trace( items );
	}

	/**
	  * Listen for events on the Stage
	  */
	private function listen(s : Stage):Void {
		s.on('click', function(e : MouseEvent) {
			var crect = new Rectangle(x, y, (child?parent.panelWidth:w), h);
			if (child && parent.showChildren && crect.containsPoint(e.position)) {
				click( e );
			}
			else if (!child && crect.containsPoint(e.position)) {
				click( e );
			}
		});
	}

	/**
	  * Delete [this] Item entirely
	  */
	public function delete():Void {
		if (parent != null)
			parent.items.remove( this );
		else
			root.items.remove( this );
	}

	/**
	  * Append a MenuItem to [this]
	  */
	public function append(child : MenuItem):Void {
		if (!items.has( child )) {
			items.push( child );
			child.root = root;
			child.parent = this;
		}
	}

/* === Computed Instance Fields === */

	/* the 'x' position of [this] */
	public var x(get, set):Float;
	private function get_x():Float return rect.x;
	private function set_x(v : Float):Float return (rect.x = v);
	
	/* the 'y' position of [this] */
	public var y(get, set):Float;
	private function get_y():Float return rect.y;
	private function set_y(v : Float):Float return (rect.y = v);
	
	/* the width of [this] */
	public var w(get, set):Float;
	private function get_w():Float return rect.w;
	private function set_w(v : Float):Float return (rect.w = v);
	
	/* the height of [this] */
	public var h(get, set):Float;
	private function get_h():Float return rect.h;
	private function set_h(v : Float):Float return (rect.h = v);

	/* the position of [this] Menu, currently */
	public var pos(get, never):Point;
	private function get_pos():Point {
		return Point.linked(x, y);
	}

	/* the label-text of [this] MenuItem */
	public var label(get, set):String;
	private inline function get_label():String return box.text;
	private function set_label(v : String):String {
		box.text = v;
		if ( rootLevel ) {
			w = box.width;
			h = box.height;
		}
		return box.text;
	}

	/* the index of [this] item */
	public var index(get, never):Int;
	private function get_index():Int {
		return (parent != null ? parent.items : root.items).indexOf( this );
	}

	/* whether [this] is a root-level item */
	public var rootLevel(get, never):Bool;
	private inline function get_rootLevel():Bool {
		return (parent == null);
	}

	/* whether [this] is a sub-menu */
	public var subMenu(get, never):Bool;
	private inline function get_subMenu():Bool {
		return (!items.empty());
	}

	/* whether [this] is a child */
	public var child(get, never):Bool;
	private inline function get_child():Bool {
		return (parent != null);
	}

/* === Instance Fields === */

	public var root : Menu;
	public var parent : Null<MenuItem>;
	public var items : Array<MenuItem>;

	public var tooltip : Null<String>;
	public var enabled : Bool;
	public var hovered : Bool;

	public var rect : Rectangle;

	private var box : TextBox;
	private var showChildren : Bool;
	private var panelWidth : Float;
	private var panelHeight : Float;
	private var eventsBound : Bool;
	public var padding : Padding;
}
