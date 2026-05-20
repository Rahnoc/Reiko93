package idv.rs.reiko93.lab.type;

import haxe.Int32;

///
/// IntDivideExp.hx
/// Reiko93'
///
/// Created by Rahnoc on 2026/05/20.
///

/**
 * 整數相除測試。
 * 不是變 2 喔，全面變成 2.5f，跟 AS3 一樣。
 * 
 */
class IntDivideExp {
	public function new() {}

	public function run(): Void {
		trace("=============");
		trace("整數相除測試");
		trace("=============");
		primDiv();
		haxeToolDiv();
	}

	/// 整數相除
	function primDiv() {
		var a: Int = 5;
		var b: Int = 2;
		var c = a / b;
		output(c, "c = a / b:");
	}

	function haxeToolDiv() {
		var c1: Int = Std.int(5 / 2);
		var c2: Float = Math.floor(5 / 2); // 保持為 Float 的 2.0，最適合像素對齊

		output(c1, "c1: Int = Std.int(5 / 2):");
		output(c2, "c2: Float = Math.floor(5 / 2):");
	}

	function output(a: Any, desc: String) {
		var t = Type.typeof(a);
		trace('$desc $a ($t)');
	}
}
