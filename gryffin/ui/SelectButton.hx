package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;
import gryffin.ui.*;

import tannus.geom.*;
import tannus.events.*;
import tannus.graphics.Color;
import tannus.ds.Delta;
import tannus.io.Signal;

import Std.string in s;

using StringTools;
using tannus.ds.StringUtils;
using Lambda;
using tannus.ds.ArrayTools;

class SelectButton<T> extends GenericButton {
	/* Constructor Function */
	public function new():Void {
		super();

		options = new Array();
		selectedIndex = 0;
		prefix = '';
		suffix = '';
		change = new Signal();

		on('click', _click);
	}

/* === Instance Methods === */

	/**
	  * update [this] Button
	  */
	override public function update(stage : Stage):Void {
		super.update( stage );

		var o = selectedOption;
		text = (prefix + (o != null ? o.text : '') + suffix);
	}

	/**
	  * add an Option
	  */
	public function option(text:String, value:T):Void {
		options.push(new Option(text, value));
	}

	/**
	  * when [this] Button gets clicked
	  */
	public function _click(event : MouseEvent):Void {
		var prev = value;
		if (selectedIndex >= (options.length - 1)) {
			selectedIndex = 0;
		}
		else {
			selectedIndex++;
		}

		var delta = new Delta(value, prev);
		change.call( delta );
	}

/* === Computed Instance Fields === */

	/* the currently selected Option */
	public var selectedOption(get, never):Null<Option<T>>;
	private inline function get_selectedOption():Null<Option<T>> {
		return options[selectedIndex];
	}

	public var value(get, never):Null<T>;
	private inline function get_value():Null<T> {
		return (selectedOption != null ? selectedOption.value : null);
	}

/* === Instance Fields === */

	public var options : Array<Option<T>>;
	public var selectedIndex : Int;
	public var prefix : String;
	public var suffix : String;
	public var change : Signal<Delta<T>>;

/* === Static Methods === */

	/**
	  * From a Map
	  */
	public static function fromMap<T>(map : Map<String, T>):SelectButton<T> {
		var btn:SelectButton<T> = new SelectButton();
		for (key in map.keys()) {
			btn.option(key, map[key]);
		}
		return btn;
	}
}

class Option<T> {
	public function new(txt:String, val:T):Void {
		text = txt;
		value = val;
	}

/* === Instance Fields === */

	public var text : String;
	public var value : T;
}
