package gryffin.core;

import tannus.css.StyleSheet;

import js.html.StyleElement;

class StageFiller {
/* === Static Methods === */

	/**
	  * Builds the StyleSheet
	  */
	public static function sheet():Void {
		if ( !addedStyleSheet ) {
			var sheet:StyleSheet = new StyleSheet();
			
			var all = sheet.rule('*', {
				'margin': 0,
			    	'padding': 0
			});

			var bodyAndHtml = sheet.rule('body, html', {
				'height': '100%'
			});

			var canvas = sheet.rule('canvas', {
				'position': 'absolute',
			    	'width': '100%',
			    	'height': '100%'
			});

			var element = sheetElement( sheet );
			js.Browser.document.getElementsByTagName('head').item(0).appendChild( element );

			addedStyleSheet = true;
		}
	}

	/**
	  * Convert a StyleSheet into an Element
	  */
	private static function sheetElement(sheet : StyleSheet):StyleElement {
		var el:StyleElement = js.Browser.document.createStyleElement();
		el.type = 'text/css';
		el.textContent = sheet.toString();
		return el;
	}

/* === Static Fields === */

	/* variable to store whether the StyleSheet has been created */
	private static var addedStyleSheet:Bool = false;
}
