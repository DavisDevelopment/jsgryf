package gryffin.audio;

typedef TypedArray<T> = {
	var length(default, never):Int;

	function get(index : Int) : T;
	//function set(index:Int, value:T):Void;
	function subarray(start:Int, ?end:Int):TypedArray<T>;
};
