package gryffin.display;

import js.html.CanvasRenderingContext2D in Cd;

import gryffin.display.Context;

@:forward
abstract Ctx (Context) from Context to Context {
	public inline function new(c : Cd):Void {
		this = new Context( c );
	}

	@:from
	public static inline function fromC2d(c : Cd):Ctx {
		return new Ctx( c );
	}
}
