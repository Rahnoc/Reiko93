package idv.rs.reiko93.lab.type;

import haxe.Int32;

///
/// NumConvExp.hx
/// Reiko93'
///
/// Created by Rahnoc on 2026/05/20.
///

/**
 * Int 32 與 Float (靜態 32 動態 64) 的轉換與溢位測試。
 * 
 * C/C++ static = 32bit
 * JavaScript = 64bit
 * 
 * 以 直譯與 JS 為輸出目標來比較。
 * 直譯時，正好溢位變負數。
 * JS
 */
class NumConvExp {
	public function new() {}

	public function run() {
		trace("--- 開始 Haxe Float64 轉 Int32 邊界測試 ---");

		// 1. 正常小數測試（朝 0 捨去）
		testCast(123.45, "正常正小數");
		testCast(-123.45, "正常負小數");

		// 2. 剛好在 32-bit 邊界的極限值
		testCast(2147483647.0, "32-bit 最大正整數");
		testCast(-2147483648.0, "32-bit 最小負整數");

		// 3. 超過 32-bit 的溢位數值（此處最容易看出平台差異！）
		testCast(2147483648.5, "剛好超過上限 1");
		testCast(5000000000.0, "大幅度超過 32-bit 的大數");

		// 4. 特殊浮點數測試
		testCast(Math.NaN, "NaN 測試");
		testCast(Math.POSITIVE_INFINITY, "正無限大");
	}

	function testCast(f: Float, description: String) {
		// 使用 Std.int 進行標準轉型
		// var resultInt:Int = Std.int(f);
		// 用安全轉換
		var resultInt: Int = safeIntV2(f);

		// 為了確保輸出時的行為，強制轉換為強制的 Int32 顯示位元結果
		var bitwise32: Int32 = cast resultInt;

		trace('${description} [輸入 Float: ${f}]');
		trace('  -> 轉型後 Int 結果: ${resultInt}');
		trace('  -> 強制 32-bit 位元表現: ${bitwise32}');
	}

	// -----------------
	// 安全轉換用
	// -----------------
	// 追求「絕對安全」（全部比照 HashLink 的飽和截斷）
	public static inline function safeInt(f: Float): Int {
		if (Math.isNaN(f))
			return 0;
		if (f >= 2147483647.0)
			return 2147483647;
		if (f <= -2147483648.0)
			return -2147483648;
		return Std.int(f);
	}

	// 追求「精準位元迴繞」（全部比照 JS/hxcpp 的 2^32 模運算）
	public static inline function safeIntWrapAround(f: Float): Int {
		if (!Math.isFinite(f))
			return 0; // 擋掉 NaN 和 Infinity，使其輸出一致

		#if js
		return Std.int(f); // JS 原生就是位元迴繞
		#else
		// 利用 Haxe Int32 模組的精準數學公式，強迫 C/C++ 平台進行 32 位元迴繞
		// 這樣不論在 HL/C 還是 hxcpp，5000000000 算出來一律都是 705032704
		var r = f % 4294967296.0;
		if (r >= 2147483648.0)
			r -= 4294967296.0;
		else if (r < -2147483648.0)
			r += 4294967296.0;
		return Std.int(r);
		#end
	}

	/**
	 * 高效跨平台安全轉型 (適合一般遊戲與商業系統)
	 * 先在 Float 安全區抹平小數分歧，再交給標準轉型。
	 */
	public static inline function safeIntV2(f: Float): Int {
		// 1. 防禦 NaN 與無限大，安全歸零
		if (!Math.isFinite(f))
			return 0;

		// 2. 率先在 Float 層面將小數點朝 0 捨去 (抹平邊界與像素跳動)
		var cleanedF: Float = f < 0 ? Math.ceil(f) : Math.floor(f);

		// 3. 處理 Haxe 直譯器 (Eval VM) 在整數極限邊界上的先天記憶體缺陷
		//    如果剛好貼在 -2147483648 附近，直接用有號整數極值返回，防止直譯器將其抹零
		#if interp
		if (cleanedF <= -2147483648.0)
			return -2147483648;
		if (cleanedF >= 2147483647.0)
			return 2147483647;
		#end

		// 4. 清乾淨的浮點數直接轉型，這時各大平台（JS/C++/HL）皆能跑出極致效能與穩定數值
		return Std.int(cleanedF);
	}
}
