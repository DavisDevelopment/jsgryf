package gryffin.ui;

import tannus.events.MouseEvent;

@:forward
abstract Button (TButton) from TButton to TButton {
	/* Constructor Function */
	public inline function new(data : TButton):Void {
		this = data;
	}
}

typedef TButton = {
	var text : String;
	var click : MouseEvent -> Void;
}
