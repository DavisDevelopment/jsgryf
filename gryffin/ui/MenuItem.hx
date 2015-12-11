package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.graphics.Color;
import tannus.ds.Obj;
import tannus.events.MouseEvent;
import tannus.math.TMath.*;

import Reflect.*;
import gryffin.Tools.defer;

using Lambda;
using tannus.ds.ArrayTools;

@:allow( gryffin.ui.Menu )
class MenuItem extends EventDispatcher {
	/* Constructor Function */
	public function new(?options : Obj):Void {
		super();

		type = 'normal';
		icon = null;
		checkIcon = Image.load('../assets/check.png');
		rect = new Rectangle();
		parent = null;
		items = new Array();
		showChildren = false;
		eventsBound = false;
		tooltip = null;
		enabled = true;
		checked = false;
		hovered = false;
		hoverStart = null;
		beenHovered = 0;

		box = new TextBox();
		keyBox = new TextBox();
		keyBox.fontSize = box.fontSize = 11;
		keyBox.fontFamily = box.fontFamily = 'Ubuntu';
		box.color = '#FFF';
		keyBox.color = box.color.darken( 45 );

		padding = new Padding();
		padding.horizontal = 5;
		padding.vertical = 5;

		if (options != null)
			handleOptions( options );

		on('open', function(x) trace('opening $label'));
	}

/* === Instance Methods === */

	/**
	  * Render [this] MenuItem
	  */
	public function render(s:Stage, c:Ctx):Void {
		/* highlight [this] item if it's at root level and is currently hovered */
		if (rootLevel && (hovered || showChildren)) {
			c.beginPath();
			c.fillStyle = '#f17746';
			c.strokeStyle = '#111';

			/* == do the stuff == */
			var r:Float = 5;
			var cb:Float = (root.y + root.h);
			var pxl = (x - padding.left);
			var pxr = (x + w + padding.right);
			var pyt = (y - padding.top);

			c.moveTo(pxl, cb);
			c.lineTo(pxl, (pyt + r));
			c.quadraticCurveTo(pxl, pyt, (pxl + r), pyt);
			c.lineTo((pxr - r), pyt);
			c.quadraticCurveTo(pxr, pyt, pxr, (pyt + r));
			c.lineTo(pxr, cb);
			c.lineTo(pxl, cb);

			c.closePath();
			c.stroke();
		}

		/* render children if we have any and [showChildren] is currently true */
		if (subMenu && showChildren) {
			for (item in items) {
				item.render(s, c);
			}
		}

		/* draw background if [this] item is a child of another */
		if ( child ) {
			c.fillStyle = (hovered ? '#f17746' : root.backgroundColor.toString());
			c.fillRect(x, y, parent.panelWidth, (h + padding.vertical));
		}

		// draw the checkbox-icon
		if (type == 'checkbox' && checked) {
			var i = checkIcon;
			var size = (h + padding.vertical);
			c.drawComponent(i, 0, 0, i.width, i.height, x, y, size, size);
		}

		// draw the icon
		var th:Float = (h + padding.vertical);
		var tx:Float = (child ? (x + th) : x);
		var ty:Float = (child ? (y + padding.top) : y);
		if (icon != null) {
			c.drawComponent(icon, 0, 0, icon.width, icon.height, (x + th), y, th, th);
			tx += (th + 8);
		}

		// draw the label
		c.drawComponent(box, 0, 0, box.width, box.height, tx, ty, box.width, box.height);

		// draw the 'key' label, if such a value has been defined
		if (key != '') {
			var xo:Float = (child ? parent.panelWidth : w);
			c.drawComponent(keyBox, 0, 0, keyBox.width, keyBox.height, ((x + xo) - (keyBox.width + 5)), ty, keyBox.width, keyBox.height);
		}
	}

	/**
	  * Update [this] MenuItem
	  */
	public function update(stage : Stage):Void {
		// bind relevant events, if we haven't done so already
		if ( !eventsBound ) {
			listen( stage );
			eventsBound = true;
		}

		var _hovered:Bool = hovered;

		// check whether the mouse cursor is currently inside of [this] item
		var mouse =  stage.getMousePosition();
		var crect = new Rectangle(x, y, (child?parent.panelWidth:w), (h + padding.vertical));
		if (mouse != null) {
			hovered = crect.containsPoint(mouse);
			/* hover is continuing */
			if (_hovered && hovered) {
				var now = (Date.now().getTime());
				beenHovered = (now - hoverStart);
			}
			/* hover has begun */
			else if (!_hovered && hovered) {
				hoverStart = (Date.now().getTime());
			}

			/* hover has ended */
			else if (_hovered && !hovered) {
				hoverStart = null;
				beenHovered = 0;
			}
		}

		// if we're being hovered over, indicate that [this] can be clicked
		if ( hovered ) {
			stage.cursor = 'pointer';
		}

		// reposition [this]'s children is they're to be rendered
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
		if (items.length == 0)
			return ;
		var iy:Float = 0;
		for (item in items) {
			item.update( s );

			// ensure that the total width of the 'panel' is the width of the widest child, increased by 30
			var itemHeight = (item.padding.top + item.box.height + item.padding.bottom);
			var itemWidth = ((item.box.width + item.keyBox.width + 20) + (itemHeight * 3) + 8);
			panelWidth = max(panelWidth, itemWidth);

			if (subMenu && child) {
				item.y = (y + iy);
				item.x = (x + w + 30);
				iy += item.padding.bottom;
			}
			else {
				item.y = (root.y + root.h + iy);
				item.x = x;
				iy += itemHeight;
			}
		}
		var ph:Float = panelHeight;
		panelHeight = iy;
		var li = items[items.length - 1];
		panelHeight += (li.h + li.padding.vertical);
	}

	/**
	  * When [this] MenuItem gets clicked on
	  */
	public function click(e : MouseEvent):Void {
		if (type == 'normal') {
			var sc:Bool = showChildren;
			root.itemClicked( this );
			if (subMenu)
				showChildren = !sc;
			dispatch('click', e);
		}
		else if (type == 'checkbox') {
			root.itemClicked( this );
			checked = !checked;
			dispatch((!checked?'un':'')+'check', e);
		}
	}

	/**
	  * Listen for events on the Stage
	  */
	private function listen(s : Stage):Void {
		var lastEvent:Null<MouseEvent> = null;
		s.on('click', function(e : MouseEvent) {
			if (e == lastEvent)
				trace('click handler is bound multiple times');
			var crect = new Rectangle(x, y, (child?parent.panelWidth:w), h);
			if (child && parent.showChildren && crect.containsPoint(e.position)) {
				click( e );
			}
			else if (!child && crect.containsPoint(e.position)) {
				click( e );
			}
			lastEvent = e;
		});
	}

	/**
	  * Handle the provided options
	  */
	private function handleOptions(o : Obj):Void {
		/* copy over the 'label' value */
		if (o.exists('label'))
			label = o['label'];

		/* copy over the 'key' value */
		if (o.exists('key'))
			key = o['key'];

		/* copy over the 'type' value */
		if (o.exists('type'))
			type = o['type'];

		/* copy over the 'icon' value */
		if (o.exists('icon'))
			icon = Image.load(o['icon']);
		
		/* bind the 'click' handler, if provided */
		if (o.exists('click')) {
			var oclick:Dynamic = o['click'];
			if (Reflect.isFunction( oclick )) {
				on('click', untyped oclick);
			}
		}

		/* bind the 'open' handler, if provided */
		if (o.exists('open') && isFunction(o['open']))
			on('open', untyped o['open']);

		/* bind the 'close' handler, if provided */
		if (o.exists('close') && isFunction(o['close']))
			on('close', untyped o['close']);
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

	/**
	  * Perform chroma-key replacement on the check-icon
	  */
	private function makeWhite():Void {
		var black:Color = new Color();
		var c:Canvas = checkIcon.toCanvas();
		var p = c.context.pixels(0, 0, c.width, c.height);
		for (i in 0...p.length) {
			var c = p.getAtIndex( i );
			if (c == black)
				p.setAtIndex(i, !c);
		}
		p.save();
		checkIcon = Image.load(c.dataURI());
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
			w = (box.width + keyBox.width);
			h = (box.height);
		}
		return box.text;
	}

	/* the key-command for [this] MenuItem */
	public var key(get, set):String;
	private inline function get_key():String return keyBox.text;
	private function set_key(v : String):String {
		keyBox.text = v;
		if ( rootLevel ) {
			w = (box.width + keyBox.width);
			h = (box.height);
		}
		return keyBox.text;
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

	/* whether to render child-items of [this] */
	private var showChildren(default, set):Bool;
	private function set_showChildren(v : Bool):Bool {
		dispatch(v?'open':'close', null);
		return (showChildren = v);
	}

/* === Instance Fields === */

	public var root : Menu;
	public var parent : Null<MenuItem>;
	public var items : Array<MenuItem>;

	public var type : String;
	public var tooltip : Null<String>;
	public var icon : Null<Image>;
	public var enabled : Bool;
	public var hovered : Bool;
	public var checked : Bool;

	public var rect : Rectangle;

	private var box : TextBox;
	private var keyBox : TextBox;
	private var panelWidth : Float;
	private var panelHeight : Float;
	private var eventsBound : Bool;
	private var hoverStart : Null<Float>;
	private var beenHovered : Float;
	private var checkIcon : Image;
	public var padding : Padding;
}
