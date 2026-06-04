/**
	ShadowScope.hx
	Reiko93'

	Created by Rahnoc on 2026/05/27.
**/

package idv.rs.reiko93.lab.scope;

/**
	局部遮蔽測試
**/
class ShadowScope {
	private var r: Int;
	private var g: Int;
	private var b: Int;
	private var a: Int;

	public function new(r: Int = 0, g: Int = 0, b: Int = 0, a: Int = 0) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public function reset(r: Int, g: Int, b: Int, a: Int) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}

	public var desc(get, null): String;

	public function get_desc(): String {
		return 'R$r G$g B$b A$a';
	}

	public static function fromRGBAi(r: Int, g: Int, b: Int, a: Int): ShadowScope {
		return new ShadowScope(r, g, b, a);
	}

	// ---------------
	public var ri(get, set): Int;

	inline function get_ri()
		return r;

	// 參數與prop同名時，遮蔽。
	inline function set_ri(ri: Int) {
		reset(ai, ri, gi, bi);
		return ri;
	}

	public var gi(get, set): Int;

	inline function get_gi()
		return g;

	inline function set_gi(gi: Int) {
		reset(ai, ri, gi, bi);
		return gi;
	}

	public var bi(get, set): Int;

	inline function get_bi()
		return b;

	inline function set_bi(bi: Int) {
		reset(ai, ri, gi, bi);
		return bi;
	}

	public var ai(get, set): Int;

	inline function get_ai()
		return a;

	inline function set_ai(ai: Int) {
		reset(ai, ri, gi, bi);
		return ai;
	}
}
