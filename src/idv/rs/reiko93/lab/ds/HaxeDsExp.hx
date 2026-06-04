/**
	HaxeDsExp.hx
	Reiko93'

	Created by Rahnoc on 2026/05/27.
**/

package idv.rs.reiko93.lab.ds;

/**
	DS exp.
**/
class HaxeDsExp {
	public static function main() {
		run();
	}

	static function run() {
		// Rev Arr test.
		ReverseArrayKeyValueIterator.test();

		// Observer-observables test.
		var ot = new ObsTest();
		ot.run();

		// Maybe test.
		var mt = new MaybeTest();
		mt.run();
	}
}
