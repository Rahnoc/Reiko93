/**
	HaxeTypeSystemExp.hx
	Reiko93'

	Created by Rahnoc on 2026/05/24.
**/

package idv.rs.reiko93.lab.typeSystem;

import idv.rs.reiko93.lab.typeSystem.param.HxGenericClass;
import idv.rs.reiko93.lab.typeSystem.param.HxTypeDefault;
import idv.rs.reiko93.lab.typeSystem.param.HxTypeConstrain;
import idv.rs.reiko93.lab.typeSystem.param.HxTypeParam;

/**
	Type system exp.
**/
class HaxeTypeSystemExp {
	static public function main() {
		run();
	}

	static function run() {
		var tpExp = new HxTypeParam();
		tpExp.run();

		var tcExp = new HxTypeConstrain();
		tcExp.run();

		var tdExp = new HxTypeDefault();
		tdExp.run();

		var gcExp = new HxGenericClass();
		gcExp.run();
	}
}
