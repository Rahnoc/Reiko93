package idv.rs.reiko93.lab.hxDyna;

/**
 * 針對 Any 判斷與轉型
 */
class HaxeDynaExp {
	static function setAnyValue(value: Any) {
		trace(value);
	}

	static function getAnyValue(): Any {
		return 42;
	}

	static function main() {
		// 任意型式的值都可工作
		setAnyValue("someValue");
		setAnyValue(42);

		var value = getAnyValue();
		// $type 會以 warning 方式，輸出會在最後。
		$type(value); // 會是 Any 而不是 Unknown<0>

		// 無法編譯：沒有動態欄位存取
		// value.charCodeAt(0);

		// 確認
		if (Std.isOfType(value, String)) {
			trace((value : String).charCodeAt(0));
		} else {
			// 轉型
			if (Std.isOfType(value, Int)) {
				var castResult = cast(value, Int);
				trace('safe cast as > $castResult');
			}
		}

		var aC = getAnyValue();
		var cC: Int = cast aC;
		trace('unsafe cast > $cC');

		// runtime error
		// var bCastResult: Bool = cast(aC, Bool);
	}
}
