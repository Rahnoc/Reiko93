package idv.rs.reiko93.lab.flow;

/**
	For enum & enum abstract, and associative values tests.
**/
class EnumAsoTest {
	public function new() {}

	public function run() {
		trace('====== testEnumAsoCmp =======');
		testEnumAsoCmp();
		trace('====== testMatch =======');
		testMatch();
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

	function testMatch() {
		var absApple2 = AbsFruit.Apple2;
		var purpleApple = Fruit.Apple('Purple');

		/*
			// 不行。 阿不思會被拆成基底。 所以跟 switch(cast absApple2) 一樣。
			// 而既然是比對 Fruit， associative value 的括號就要在case 中出現。
			// 除非基底是primitive.
			switch (absApple2) {
				case Apple:
					trace('Apple');
				case Apple2:
					trace('Apple 2');
				case Plum:
					trace('Plum');
				case _:
					trace('others $absApple2');
			}
		 */
		/**
			還是基底在比對。
			如果不是列舉阿不思而是阿不思+@:to，switch裡可以加cast 當作 to 的目標用。
		**/
		trace('> AbsFruit match $purpleApple');
		switch (purpleApple) {
			case Apple(color):
				trace('apple $color');
			case Banana(size):
				trace('banana $size');
			default:
				trace('others $absApple2');
		}

		/**
			`列舉阿不思`原本設計的目的。
			作為基底包裝，且 static var 漏打時，可以在編譯期抓出 Unmatched patterns。
			九成九像是 enum。
		**/
		var po = AbsPaperFruit.PaperOrange;
		trace('> AbsPaperFruit match $po');
		switch (po) {
			case PaperApple:
				trace('Paper Apple');
			case PaperBanana:
				trace('Paper Banana');
			case PaperOrange:
				trace('Paper Orange');
			default: // 要是沒打default 導致沒有把 AbsPaperFruit 列完，會編譯報錯。
				trace('Others: $po');
		}
	}
}

private enum Fruit {
	Apple(color: String);
	Banana(size: String);
	Plum(amount: Int);
}

/**
	這樣用 apple 與 apple2 因為基底一樣，會被吃掉。
	根本沒辦法 switch 在 Apple 與 Apple2 之間。
**/
private enum abstract AbsFruit(Fruit) from Fruit to Fruit {
	public static var Apple: AbsFruit = Fruit.Apple('Red');
	public static var Apple2: AbsFruit = Fruit.Apple('Red');
	public static var Apple3: AbsFruit = Fruit.Apple('Crimson');
	public static var Banana: AbsFruit = Fruit.Banana('big');
	public static var Plum: AbsFruit = Fruit.Plum(4);
}

/**
	`列舉阿不思` 會幫你加from to。 裡面的會幫你盡量加 public static inline var。
	switch 會檢查有沒有漏。
**/
private enum abstract AbsPaperFruit(String) {
	var PaperApple = "PA";
	var PaperBanana = "PB";
	var PaperGrape = "PG";
	var PaperOrange = "PO";
}

/**
	enum 更像是建構的工具，而不是像 Swift 的 enum 是 struct 之類的 instance。

	針對已知狀態要 switch 比對，應該用 struct 列出所有狀態，然後去一一比對。
	enum 的 constructor 可以拿來用在這情境來 switch 只是剛好。

	如果 enum constructor 要包含參數，代表是執行期的東西，應該是 instance 後有實體。
	應該要有正式表達方式。

	建議`列舉阿不思`包個 int，然後查表去連結到正式資料。 不用勉強跟 enum 扯上關係。
	畢竟好處就只有 switch 編譯期會幫你掃數不是有漏而已。

	如果是對射，列舉阿不思包 enum，在查表去找對應資料也是可以。

	1a. enum abst(Int)，反查 data 與 enum。

	1b. 變體 enum abst({idx:int, 其他}) 反查 enum。

	2. enum abst(enum)，反查 data。 index需要同步。用 Type.enumIndex(this) 之類的去抓。

	結論：若要依賴 swift 的思維，associative value 使用時機需考慮(或少用)。 Haxe enum 可以 switch 只是剛好。
**/
