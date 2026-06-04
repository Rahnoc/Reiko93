package idv.rs.reiko93.lab.ds;

import idv.rs.reiko93.lab.ds.Maybe;

/**
	測試 nil處理用的 Maybe 類別。
 */
class MaybeTest {
	public function new() {}

	public function run() {
		// initialize from null...
		var value: Maybe<Int> = null;

		// ...or a value of underlying type
		value = 10;
		// compilation errors, so you can't use Maybe<T> without explicit unwrapping
		// var v:Int = value;
		// var v = value + 5;
		// get value or raise exception
		var v = value.unwrap();

		// get value or use default
		var v = value.or(0);

		// check whether value exists
		if (value.isNotNull())
			trace("value exists!");
		// execute function if value exists
		value.ifLet(function(value) trace("Value is " + value));
		// map value to Maybe<String>
		var valueString = value.map(function(value) return Std.string(value));
		trace('valueString = $valueString');

		// map value to String or use default string
		var message = value.mapOr(function(value) return "Value is " + value, "No value");
		trace('message = $message');
	}
}
