package idv.rs.reiko93.lab.typeSystem.param;

///
/// HxTypeConstrain.hx
/// Reiko93'
///
/// Created by Rahnoc on 2026/05/24.
///

typedef Measurable = {
	public var length(default, null): Int;
}

/**
 * Type constrain test.
 */
class HxTypeConstrain {
	public function new() {}

	public function run() {
		trace('=== Test start ===');
		trace(test([]));
		trace(test(["bar", "foo", "ooh"]));
		// String should be Iterable<String>
		// test("foo");

		trace(test2([]));
		var arr = ["bar", "foo", "ooh"];
		trace(test2(arr));
	}

	#if (haxe_ver >= 4)
	static function test<T: Iterable<String> & Measurable>(a: T) {
	#else
	static function test<T: (Iterable<String>, Measurable)>(a: T) {
	#end
		if (a.length == 0)
			return "empty";

		return a.iterator().next();
	}
	//
	static function test2<T: Iterable<String>>(a: T) {
		return a.iterator().next();
	}
}
