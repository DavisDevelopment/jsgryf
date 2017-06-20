package gryffin.display;

import gryffin.display.CPixels;

import haxe.macro.Context;
import haxe.macro.Expr;
import tannus.macro.MacroTools in Mt;

using haxe.macro.ExprTools;
using tannus.macro.MacroTools;

@:forward
abstract Pixels (CPixels) from CPixels to CPixels {
	/* Constructor Function */
	public inline function new(i : ImageData):Void {
		this = new CPixels( i );
	}

/* === Instance Methods === */

	/**
	  * Macro-licious method to manipulate [this] Pixels as fast as possible
	  */
	public macro function applyShader(self:ExprOf<Pixels>, args:Array<Expr>) {
		var action:Expr = args.shift();
		
		action = action.map( PixelsTools.shaderReplacer );
		action = action.replace(macro red, macro data[i]);
		action = action.replace(macro green, macro data[i + 1]);
		action = action.replace(macro blue, macro data[i + 2]);
		action = action.replace(macro alpha, macro data[i + 3]);
		
		var block:Expr = macro {
			var i:Int = 0;
			var data = $self.imageData.data;
			while (i < data.length) {
				$action;
				
				i += 4;
			}
		};

		return block;
	}

	/**
	  * macro-licious method to iterate over [this] as fast as possible
	  */
	public macro function doScript(self:ExprOf<Pixels>, args:Array<Expr>) {
	    var interval:Int = 1;
	    if (args.length > 1) {
	        switch (args[0].expr) {
                case EConst(Constant.CInt(Std.parseInt(_) => i)):
                    interval = i;
                    args.shift();

                default:
                    null;
	        }
	    }

	    var action:Expr = args.shift();
	    var referencesColor:Bool = false;

	    action.iter(function(e : Expr) {
	        switch ( e.expr ) {
                case EConst(CIdent('color')):
                    referencesColor = true;

                default:
                    return ;
	        }
	    });

        var rce:Array<Expr> = [macro null, macro null];
        if (referencesColor) {
            rce[0] = macro var _c = new tannus.graphics.Color();
            rce[1] = macro _c = new tannus.graphics.Color(data[i],data[i+1],data[i+2],data[i+3]);
        }
		action = action.replace(macro red, macro data[i]);
		action = action.replace(macro green, macro data[i + 1]);
		action = action.replace(macro blue, macro data[i + 2]);
		action = action.replace(macro alpha, macro data[i + 3]);
		if (referencesColor)
		    action = action.replace(macro color, macro _c);

		return macro {
		    var i:Int = 0;
		    var data = $self.imageData.data;
		    ${rce[0]};
		    while (i < data.length) {
		        ${rce[1]};
		        $action;
		        i += $v{4 * interval};
		    }
		};
	}
}

class PixelsTools {
	public static function shaderReplacer(e : Expr):Expr {
		switch ( e.expr ) {
			case EConst(CIdent('color')):
				return macro [red, green, blue];
				/*
				return {
					expr: ENew('tannus.graphics.Color'.toTypePath(), [macro red, macro green, macro blue, macro alpha]),
					pos: e.pos
				};
				*/

			case ExprDef.EBinop(OpAssign, left, right):
				switch ( left.expr ) {
					case EConst(CIdent('color')):
						return (macro {
							var col = $right;
							red = col[0];
							green = col[1];
							blue = col[2];
							//alpha = col.alpha;
						}).map( shaderReplacer );

					default:
						return e.map( shaderReplacer );
				}

			default:
				return e.map( shaderReplacer );
		}
	}
}
