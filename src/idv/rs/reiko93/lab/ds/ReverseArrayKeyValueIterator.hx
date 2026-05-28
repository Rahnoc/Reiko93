package idv.rs.reiko93.lab.ds;

using idv.rs.reiko93.lab.ds.ReverseArrayKeyValueIterator;

/**
 * Rev Arr.
 */
class ReverseArrayKeyValueIterator<T> {
	final arr: Array<T>;
	var i: Int;

	public inline function new(arr: Array<T>) {
		this.arr = arr;
		this.i = this.arr.length - 1;
	}

	public inline function hasNext()
		return i > -1;

	// struct must has key and value props (不記順序)。
	// > 官方 Iterator 實作要求的。
	public inline function next() {
		return {value: arr[i], key: i--};
	}

	public static inline function reversedKeyValues<T>(arr: Array<T>) {
		return new ReverseArrayKeyValueIterator(arr);
	}

	// ------------

	public static function test() {
		var fruits = ["apple", "banana", "pear"];
		for (idx => fruit in fruits.reversedKeyValues()) {
			trace(idx, fruit);
		}
	}
}
