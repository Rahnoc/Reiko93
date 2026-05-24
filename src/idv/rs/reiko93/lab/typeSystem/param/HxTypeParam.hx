package idv.rs.reiko93.lab.typeSystem.param;

/**
 * <T> 對於同 type 參數的編譯期限制測試。
 */
class HxTypeParam {
	public function new() {}

	public function run() {
		trace('=== Test start ===');
		equals(1, 1);
		// runtime message: bar should be foo
		// 形態同，但內容不同。
		equals("foo", "bar");
		// compiler error: type dismatch, String should be Int
		// 編譯期就會擋住。
		// equals(1, "foo");
	}

	// 比對值。
	// 能比較的前提是 type <T> 相同。
	function equals<T>(expected: T, actual: T) {
		if (actual != expected) {
			trace('$actual should be $expected');
		} else {
			trace('$expected $actual is equal!');
		}
	}
}
