package idv.rs.reiko93.lab.num;

using idv.rs.reiko93.lab.num.TypeInfoTools;

/**
 * int float 轉型測試
 */
class NumCast {
	public function new() {}

	public function run() {
		intToFloat();
		floatToInt();
		rdConv();
		projTest(Math.PI / 6 * 5);
		findAngle();
	}

	function intToFloat() {
		var i: Int = 42;
		var f1: Float = i;
		var f2: Float = cast(i, Float);
		var f3: Float = cast i;

		trace(42.toInfoString());
		trace(f1.toInfoString());
		trace(Type.typeof(42));
		trace(Type.typeof(f1));
		trace(Std.isOfType(24, Float));
		trace(Std.isOfType(f1, Float));
		trace(i is Float);
		trace(f1 is Float);

		$type(f1);
		$type([f1, f2, f3]);
		trace([f1.toInfoString(), f2.toInfoString(), f3.toInfoString()]);
		var resultArr = [f1, f2, f3].map(o -> o.toInfoString());
		trace(resultArr.join(", "));

		// 編譯期 $type() 宣告什麽就什麼。
		// 執行後 Type.typeof ，如果能當作 Int 就會被當做 Int。
		// 而 Std.isOfType / is 判斷還是能知道是 Float 。
	}

	function floatToInt() {
		var value: Float = 3.3;
		var i1 = Std.int(value);
		var i2 = Math.floor(value);
		var i3 = Math.round(value);
		var i4 = Math.ceil(value);

		trace(i1.toInfoString());
		trace(i2.toInfoString());
		trace(i3.toInfoString());
		trace(i4.toInfoString());
	}

	function rdConv() {
		var radians = Math.PI * 2;
		var degrees = radians * 180 / Math.PI;
		var radians = degrees * Math.PI / 180;

		var r = radians / Math.PI;
		trace('r=$r d=$degrees');
		trace(r.toInfoString());
	}

	function projTest(angle: Float) {
		var distance = 100;
		var x = Math.cos(angle) * distance;
		var y = Math.sin(angle) * distance;

		trace('$x $y');
	}

	function findAngle() {
		var point1 = {x: 350, y: 0}
		var point2 = {x: 350, y: 150}

		var dx = point2.x - point1.x;
		var dy = point2.y - point1.y;
		var angleRad = Math.atan2(dy, dx);
		var angleDeg = angleRad / Math.PI * 180;

		// angle in radians (使用弧度為單位)
		trace(angleRad); // 1.5707 = PI/2 = 0.5pi
		// angle in degrees (使用角度為單位)
		trace(angleDeg); // 90
	}
}
