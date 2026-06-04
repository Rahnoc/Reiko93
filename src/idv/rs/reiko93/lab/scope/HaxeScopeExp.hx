/**
	HaxeScopeExp.hx
	Reiko93'

	Created by Rahnoc on 2026/05/27.
**/

package idv.rs.reiko93.lab.scope;

import idv.rs.reiko93.lab.scope.ColorExt.Color;

/**
	Scope exp.
**/
class HaxeScopeExp {
	public static function main() {
		run();
	}

	public static function run() {
		var ss = new ShadowScope();
		ss.ri = 12;
		trace(ss.desc);

		// -----------

		var iScope = new InnerScope();
		iScope.test(9);
		trace(iScope.toString());

		// ------------

		// Use a predefined color
		var red: Color = Color.RED;
		// Use a custom color
		var fromInt: Color = 0x98765432;
		var fromString: Color = "0xffeeddcc";
		var fromIntComponents: Color = Color.fromARGBi(255, 125, 100, 50);
		var fromFloatComponents: Color = Color.fromARGBf(1.0, 0.3, 0.7, 0.2);
		// Access color channels
		fromIntComponents.ri = red.ri;
		fromString.af = 1.0;
		// Print out the hex values
		trace(StringTools.hex(red));
		trace(StringTools.hex(fromInt));
		trace(StringTools.hex(fromString));
		trace(StringTools.hex(fromIntComponents));
		trace(StringTools.hex(fromFloatComponents));
	}
}
