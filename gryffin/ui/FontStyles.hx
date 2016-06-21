package gryffin.ui;

class FontStyles {
	/* Constructor Function */
	public function new(?fam:String, ?siz:Int):Void {
		family = 'Arial';
		size = 12;
		sizeUnit = 'pt';

		if (fam != null)
			family = fam;
		if (siz != null)
			size = siz;
	}

/* === Instance Fields === */

	public var family : String;
	public var size : Int;
	public var sizeUnit : String;
}
