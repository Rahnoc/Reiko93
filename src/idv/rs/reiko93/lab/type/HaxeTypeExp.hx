/**
	HaxeTypeExp.hx
	Reiko93'

	Created by Rahnoc on 2026/05/20.
**/

package idv.rs.reiko93.lab.type;

/**
	Basic types experiment.

	::測試進入點
**/
class HaxeTypeExp {
	/**
	 * Entry point.
	 */
	static function main(): Void {
		var obj = new HaxeTypeExp();
		obj.check();

		new NumConv().run();
		new IntDivide().run();
	}

	function new() {}

	function check(): Void {
		var i: Int = 39;
		var f: Float = 16777217;

		trace('i=$i f=$f');

		// 嘗試轉型
		var ci: Int = Std.int(f);

		trace(ci);
	}
}
