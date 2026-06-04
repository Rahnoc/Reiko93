package idv.rs.reiko93.lab.num;

using idv.rs.reiko93.lab.num.TypeInfoTools;

/**
	Hexidecimal 與 邊境測試
**/
class HexType {
	public function new() {}

	public function run() {
		testHex();
		testArith();
		testRnd();
		testInf();
		tetsNam();
	}

	function testHex() {
		var x = 0xE6;
		trace(x.toInfoString());
	}

	function testArith() {
		var value = 0.1 + 0.2;
		trace(value);
	}

	function testRnd() {
		// a random Int between 0 (included) and 10 (excluded)
		var r1 = Std.random(10);
		// a random Float between 0.0 (included) and 1.0 (excluded)
		var r2 = Math.random();

		trace(r1.toInfoString());
		trace(r2.toInfoString());
	}

	function testInf() {
		var value1 = 1 / 0; // infinity
		var value2 = -1 / 0; // neg-infinity

		trace(value1.toInfoString());
		trace(value2.toInfoString());
		trace(value1 == Math.POSITIVE_INFINITY); // true
		trace(value2 == Math.NEGATIVE_INFINITY); // true
	}

	function tetsNam() {
		var value = Math.sqrt(-1); // NaN

		trace(value.toInfoString());
		trace(Math.isNaN(value)); // true
	}
}
