package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.ds.Obj;
import tannus.graphics.Color;
import tannus.events.*;

class ContextMenuItem extends ListItem {
	/* Constructor Function */
	public function new(m:ContextMenu, data:Dynamic):Void {
		super();

		menu = m;
		hovered = false;
		padding = new Padding();
		box = new TextBox();
		box.fontFamily = 'Ubuntu';
		box.fontSize = 10;

		padding.vertical = 8;
		padding.horizontal = 6;

		yank( data );
	}

/* === Instance Methods === */

	/**
	  * update [this] item
	  */
	override public function update(s : Stage):Void {
		super.update( s );
		var mp = s.getMousePosition();
		if (mp != null) {
			hovered = containsPoint( mp );
			if ( hovered ) {
				s.cursor = 'point';
			}
		}
		else {
			hovered = false;
		}
	}

	/**
	  * render [this] item
	  */
	override public function render(s:Stage, c:Ctx):Void {
		c.drawComponent(box, 0, 0, box.width, box.height, (padding.left + x), (padding.top + y), box.width, box.height);
	}

	/**
	  * yank data onto [this]
	  */
	private function yank(data : Obj):Void {
		if (data.exists('label')) {
			text = data['label'];
		}
		if (data.exists('click')) {
			on('click', data['click']);
		}
	}

	/**
	  * when [this] item gets clicked
	  */
	@on('click')
	public static function click(self:ContextMenuItem, e:MouseEvent):Void {
		self.menu.delete();
	}

/* === Computed Instance Fields === */

	/* the text of [this] button */
	public var text(get, set):String;
	private inline function get_text():String return box.text;
	private inline function set_text(v : String):String return (box.text = v);

	override private function get_w():Float {
		return (padding.horizontal + box.width);
	}

	override private function get_h():Float {
		return (padding.vertical + box.height);
	}

/* === Instance Fields === */

	public var menu : ContextMenu;
	public var box : TextBox;
	public var hovered : Bool;
	public var padding : Padding;
}
