package gryffin.display;

import gryffin.display.Context;

import haxe.macro.Expr;
import haxe.macro.Context in Mac;

using Lambda;
using tannus.ds.ArrayTools;
using haxe.macro.ExprTools;
using tannus.macro.MacroTools;

@:forward
abstract Ctx (Context) from Context to Context {
	public inline function new(c : Cd):Void {
		this = new Context( c );
	}

	/**
	  * macro-shorthand for building path commands
	  */
	public macro function buildPath(self:ExprOf<Ctx>, eargs:Array<Expr>) {
		var args = eargs.map(function(e) return e.expr);
		var preamble:Expr = macro {
			_.beginPath();
		};

		switch ( args ) {
			case [EArrayDecl(values), bodydef]:
				var flags = getflags( values );
				var body:Expr = {
					pos: Mac.currentPos(),
					expr: bodydef
				};
				var footer:Expr = buildFooter( flags );
				var output:Expr = {
					pos: Mac.currentPos(),
					expr: EBlock([preamble, body, footer])
				};
				output = output.replace(macro _, self);
				return output;

			default:
				null;
		}

		var output:Expr = {pos:Mac.currentPos(), expr:EBlock([preamble,{pos:Mac.currentPos(), expr:eargs[0].expr}])};
		output = output.replace(macro _, self);
		return output;
	}

#if macro

	private static function getflags(a : Array<Expr>):Array<String> {
		var l = new Array();
		
		for (e in a) 
		l.push(switch ( e.expr ) {
			case EConst(CIdent(s)), EConst(CString(s)): s;
			default: '';
		});
		return l.filter(function(x) return (x.length > 0));
	}

	private static function buildFooter(flags:Array<String>):Expr {
		var commands:Array<Expr> = new Array();
		for (flag in flags) {
			commands.push(switch ( flag ) {
				case 'stroke': (macro _.stroke());
				case 'fill': (macro _.fill());
				case 'clip': (macro _.clip());
				default: (macro null);
			});
		}
		return macro $b{commands};
	}

#end

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
