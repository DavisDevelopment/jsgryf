package gryffin.audio.impl;

class ADIter<T> {
	private var i : IntIterator;
	private var d : IAudioData<T>;

	/* Constructor Function */
	public inline function new(ad : IAudioData<T>):Void {
		i = (0...ad.length);
		d = ad;
	}

	public inline function hasNext() return i.hasNext();
	public inline function next() return d.get(i.next());
}
