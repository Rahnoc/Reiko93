package idv.rs.reiko93.lab.num;

/**
	工具：值與型態一起輸出為字串。

	用 using 後，可以任意物件後用 .toInfoString() 來得到字串。

**/
class TypeInfoTools {
	static function examTypeInfo<T>(a: T): {value: T, info: String} {
		var ta = Type.typeof(a);
		return {
			value: a,
			info: '$ta'
		};
	}

	public static function toInfoString<T>(a: T): String {
		var tuple = examTypeInfo(a);
		var v = tuple.value;
		var t = tuple.info;
		return '$v($t)';
	}
}
