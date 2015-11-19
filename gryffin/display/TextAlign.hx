package gryffin.display;

@:enum
abstract TextAlign (String) to String from String {
	var Start = 'start';
	var End = 'end';
	var Left = 'left';
	var Right = 'right';
	var Center = 'center';
}
