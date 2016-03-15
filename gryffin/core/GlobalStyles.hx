package gryffin.core;

import tannus.css.*;
import tannus.dom.*;
import tannus.io.ByteArray;
import tannus.io.Blob;
import tannus.io.Signal;

class GlobalStyles {
	/* Constructor Function */
	public function new(s : Stage):Void {
		stage = s;
		sheet = new StyleSheet();
		link = '<link rel="stylesheet" type="text/css"/>';

		fontRules = new Array();

		initialize();
	}

/* === Instance Methods === */

	/**
	  * Create and apply the 'fill' styles
	  */
	public function fill():Void {
		sheet.rule('*', {
			'margin': 0,
			'padding': 0
		});

		sheet.rule('body, html', {
			'height': '100%'
		});

		sheet.rule('canvas', {
			'position': 'absolute',
			'width': '100%',
			'height': '100%'
		});
	}

	/**
	  * Add a Font
	  */
	public function addFont(name:String, href:String):FontFace {
		return sheet.fontFace(name, href);
	}

	/**
	  * Check whether the given Font has been added
	  */
	public function hasFont(name : String):Bool {
		return sheet.hasFontFace( name );
	}

	/**
	  * initialize [this]
	  */
	private function initialize():Void {
		var head:Element = 'head';
		head.append( link );

		listen();
	}

	/**
	  * Create and return a ByteArray of [sheet]'s contents
	  */
	private inline function getCSS():ByteArray {
		return sheet.toByteArray();
	}

	/**
	  * Convert [sheet] into a Blob, and return that Blob
	  */
	private inline function getBlob():Blob {
		return new Blob('stylesheet', 'text/css', getCSS());
	}

	/**
	  * Handle events
	  */
	private inline function listen():Void {
		sheet.onchange( update );
	}

	/**
	  * update [link] to reflect the styles in [sheet]
	  */
	private function update():Void {
		var blob = getBlob();
		link['href'] = blob.toDataURL();
	}

/* === Instance Fields === */

	public var stage : Stage;
	public var sheet : StyleSheet;
	public var link : Element;

	private var fontRules : Array<Rule>;
}
