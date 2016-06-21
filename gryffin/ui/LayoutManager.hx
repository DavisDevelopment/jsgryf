package gryffin.ui;

import gryffin.core.*;
import gryffin.display.*;

import tannus.geom.*;
import tannus.ds.tuples.Tup2 in Tuple;

import Math.*;
import tannus.math.TMath.*;

using Lambda;
using tannus.ds.ArrayTools;
using tannus.math.TMath;

class LayoutManager {
	/* Constructor Function */
	public function new(e : LayoutElement):Void {
		owner = e;
		_rows = new Array();
		_mw = 0;
	}

/* === Instance Methods === */

	/**
	  * assigns each of the given Elements to a Row
	  */
	public function recalc():Void {
		for (row in _rows) {
			removeRow( row );
		}

		for (child in owner.getElements()) {
			addElement( child );
		}
	}

	/**
	  * update the metrics for a single Element
	  */
	public function addElement(elem : LayoutElement):Void {
		var row = lastRow();
		if (row == null) {
			row = addRow(new LayoutRow());
		}

		var rr = row.previewWithElement( elem );
		if (rr.w > maxRowWidth) {
			row = addRow(new LayoutRow());
		}
		row.addElement( elem );
	}

	/* add a Row to [this] Manager */
	public function addRow(row : LayoutRow):LayoutRow {
		if (!_rows.has( row )) {
			_rows.push( row );
			row.manager = this;
		}
		return row;
	}

	/* remove a Row from [this] Manager */
	public function removeRow(row : LayoutRow):Bool {
		return _rows.remove( row );
	}

	/* get the Row (if any) which contains the given Element */
	public function getContainingRow(element : LayoutElement):Null<LayoutRow> {
		for (row in _rows) {
			if (row.hasElement( element )) {
				return row;
			}
		}
		return null;
	}

	/* get the Row at the given index */
	public inline function getRow(index : Int):Null<LayoutRow> {
		return _rows[ index ];
	}

	/* get the index of the given Row */
	public inline function getRowIndex(row : LayoutRow):Int {
		return _rows.indexOf( row );
	}

	/* get the row before the given one */
	public inline function rowBefore(r : LayoutRow):Null<LayoutRow> {
		return getRow(r.index - 1);
	}

	/* get the row after the given one */
	public inline function rowAfter(r : LayoutRow):Null<LayoutRow> {
		return getRow(r.index + 1);
	}

	public inline function lastRow():Null<LayoutRow> return getRow(_rows.length - 1);

/* === Computed Instance Fields === */

	/* the maximum row-width */
	public var maxRowWidth(get, set):Float;
	private inline function get_maxRowWidth():Float {
		return  if (_mw != null) min(owner.w, _mw)
			else owner.w;
	}
	private function set_maxRowWidth(v : Float):Float {
		_mw = v;
		recalc();
		return maxRowWidth;
	}

/* === Instance Fields === */

	public var owner : LayoutElement;
	private var _rows : Array<LayoutRow>;
	private var _mw : Null<Float> = null;
}
