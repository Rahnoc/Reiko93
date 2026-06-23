package idv.rs.reiko93.lab.flow;

class EnumAsoTest {
	public function new() {}

	public function run() {
		testEnumAsoCmp();
	}

	function testEnumAsoCmp() {
		var absApple = AbsFruit.Apple;
		var absApple2 = AbsFruit.Apple2;
		var absBanana = AbsFruit.Banana;
		var absPlum = AbsFruit.Plum;

		var blueApple = Fruit.Apple('Blue');
		var blueApple2 = Fruit.Apple('Blue');
		var fakeBlueApple = Fruit.Apple('Yellow');
		var purpleApple = Fruit.Apple('Purple');

		// Type.enumEq(a, b); 會進行 a 與 b 的 associative value 比對，等價時為true。
		// E==， 當 (a E== b) 時
		// 1. 確認左右都是同一EnumValue
		// 2. 若有associative value，則 (a.av1 E== b.av1) (a.av2 E== b.av2)
		//    > av1 若是 Enum 則會遞迴
		//    > 不是 Enum 的話，E== 就會退化為平常的 ==。
		//        > av1 為 primitive (Int/Float/Bool) 或 String，進行數值內容比對。
		//        > av1 若是其他，進行記憶體位址比對。
		//        > Dynamic 會根據實際情況，在上面兩者擇一。
		//
		// * 其他指的是 (簡單來說就是 非原生+非字串)
		//   > Class
		//   > Anonymous Structure
		//   > Array / List / Map（陣列與集合容器）
		//   > Function（函數 / 閉包）
		// * String 在有些目標(C++/HL)可能被視為「物件」，但Haxe在比對時還是比內容。 所以沒事。

		trace(Type.enumEq(absApple, absApple2)); // true 都是 apple asoVal='Red'
		trace(Type.enumEq(absApple, purpleApple)); // false 'Red' != 'Purple'
		trace(Type.enumEq(blueApple, blueApple2)); // true 都是'Blue'
		trace(Type.enumEq(blueApple, fakeBlueApple)); // false 'Blue' != 'Yellow'
		trace(Type.enumEq(blueApple, purpleApple)); // false 'Blue' != 'Purple'
		trace(Type.enumEq(blueApple, absPlum)); // false Apple 跟 Plum 的 EnumValue不同
		trace(Type.enumEq(absBanana, absPlum)); // false Banana 跟 Plum 的 EnumValue不同
	}
}

enum Fruit {
	Apple(color: String);
	Banana(size: String);
	Plum(amount: Int);
}

enum abstract AbsFruit(Fruit) from Fruit to Fruit {
	public static var Apple: AbsFruit = Fruit.Apple('Red');
	public static var Apple2: AbsFruit = Fruit.Apple('Red');
	public static var Banana: AbsFruit = Fruit.Banana('big');
	public static var Plum: AbsFruit = Fruit.Plum(4);
}
