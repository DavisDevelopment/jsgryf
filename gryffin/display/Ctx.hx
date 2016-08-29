package gryffin.display;

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

#if !macro

typedef Cd = js.html.CanvasRenderingContext2D;

#else

typedef Cd = Dynamic;

#end
