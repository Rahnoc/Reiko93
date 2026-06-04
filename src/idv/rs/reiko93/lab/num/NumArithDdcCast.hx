package idv.rs.reiko93.lab.num;

using idv.rs.reiko93.lab.num.TypeInfoTools;

/**
	自動推導轉型測試。
**/
class NumArithDdcCast {
	public function new() {}

	public function run() {
		fArith();
		iArith();
		frArith();
	}

	function fArith() {
		var a = 12;
		var b = 5;
		var c = a * 3 / b;
		// map 使用 ->
		// > Arrow Function / Lambda Expression
		// closure (no capture)
		var resultArr = [a, b, c].map(o -> o.toInfoString());
		trace(resultArr.join(", "));

		// [Int, Int, Float] 自動轉型為 Array<Float>
		// $type([a, b, c]);
	}

	function iArith() {
		var a: Int = 12;
		var b: Int = 5;
		var c = a * 3 / b;
		// map 使用 func
		// > Anonymous Function / Function Expression
		// closure (no capture)
		var resultArr = [a, b, c].map(function(o) return o.toInfoString());
		trace(resultArr.join(", "));

		// [Int, Int, Float] 自動轉型為 Array<Float>
		// $type([a, b, c]);
	}

	function frArith() {
		var a: Int = 12;
		var b: Int = 5;
		var c = Math.floor(a * 3 / b);
		// map 使用 callback hook.
		// > Static Method Reference
		// 函數指標
		var resultArr = [a, b, c].map(TypeInfoTools.toInfoString);
		trace(resultArr.join(", "));

		// [Int, Int, Int] 不用轉，就是 Array<Int>
		// $type([a, b, c]);
	}
}
