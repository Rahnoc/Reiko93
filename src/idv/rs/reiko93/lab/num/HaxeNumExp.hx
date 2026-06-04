package idv.rs.reiko93.lab.num;

/**
	Number exp.
**/
class HaxeNumExp {
	static public function main() {
		run();
	}

	static public function run() {
		trace('test start');

		trace("==============");
		var nadc = new NumArithDdcCast();
		nadc.run();

		trace("==============");
		var ht = new HexType();
		ht.run();

		trace("==============");
		var nc = new NumCast();
		nc.run();
	}
}
