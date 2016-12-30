package gryffin.math;

interface Measurable<T:Float> {
	//var width : T;
	//var height : T;
	function getWidth():T;
	function getHeight():T;
}

interface ImmutableMeasurable<T:Float> {
	var width(default, null) : T;
	var height(default, null) : T;
}
