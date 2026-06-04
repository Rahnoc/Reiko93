/**
	InnerScope.hx
	Reiko93'

	Created by Rahnoc on 2026/05/27.
**/

package idv.rs.reiko93.lab.scope;

/**
	屏蔽測試
**/
class InnerScope {
	var _a: Int = 0;
	var _b: Int = 0;

	var a(get, set): Int;

	public function get_a(): Int {
		return _a;
	}

	public function set_a(a: Int): Int {
		this._a = a;
		return a;
	}

	public function get_b(): Int {
		return _b;
	}

	public function set_b(b: Int): Int {
		this._b = b;
		return b;
	}

	var b(get, set): Int;

	public function new() {}

	// a 被覆蓋，b 沒被影響。
	public function test(a: Int) {
		this._a = a;
		this._b = b;
	}

	public function toString(): String {
		return '$_a $_b';
	}
}
