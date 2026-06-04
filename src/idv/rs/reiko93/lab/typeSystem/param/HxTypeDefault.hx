package idv.rs.reiko93.lab.typeSystem.param;

/**
	Type with defaults.
**/
class HxTypeDefault {
	public function new() {}

	public function run() {
		trace('=== Test start ===');

		// Both def.
		var x: Example = new Example();
		$type(x.a); // Int
		$type(x.b); // Int

		// Provide only first.
		var y: Example<Bool> = new Example();
		$type(y.a); // Bool
		$type(y.b); // Int

		// Assign both.
		var z: Example<String, Bool> = new Example();
		$type(z.a); // String
		$type(z.b); // Bool
	}
}

class Example<T = Int, U = Int> {
	public var a: T;
	public var b: U;

	public function new() {}
}
