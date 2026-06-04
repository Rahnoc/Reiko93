package idv.rs.reiko93.lab.typeSystem.param;

/**
	Generic class.
**/
class HxGenericClass {
	public function new() {}

	public function run() {
		trace('=== gc Test Start ===');
		var a = new MyValue<String>("Hello");
		var b = new MyValue<Int>(42);

		/*
			trace('$a');
			trace('$b');
			$type(a.value);
			trace(a.value);
			trace(b.value);
		 */
	}
}

@:generic
class MyValue<T> {
	public var value: T;

	public function new(value: T) {
		this.value = value;
	}
}
