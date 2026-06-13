/**
	EnumCompareTest.hx
	Reiko93'

	Created by Rahnoc on 2026/06/13.
**/

package idv.rs.reiko93.lab.flow;

/**
	[ISSUE] 阿不思透過 enum 來得到編譯期比對 enum case 的機能。

	但是要注意，若阿不思內的 var-case mapping 有多var對應到同樣case情況，可能會有非預期結果。

	e.g.: AbstXXX.VarA 若是與 AbstXXX.VarB 綁同一個 enum case (不管是打錯還是刻意設計)，都會 match 在同一區。
	以 AbstXXX 為主體思考時，可能會有 enum 某case 永遠跑不到的情況。 且編譯期無法得知 AbstXXX 的 var 沒覆蓋完全。
**/
/**
	# 種類 A : `[EnWrapComp]` 

	阿不思 AbsBox 包住 BoxEnum 來具備 enum match 特性。

	AbsBox 透過 @:to 對應 BoxData，來取得對應類別物件，或是牽線到實作介面。
**/ //

/**
	介面用
**/
interface IBox {
	function unpack(): Void;
}

/**
	資料用 (透過實作介面來代理)
**/
@:structInit
class BoxData implements IBox {
	public var num: Int;

	public function new(num: Int) {
		this.num = num;
	}

	public function toString(): String {
		return 'BoxData($num)';
	}

	public function unpack(): Void {
		trace('uppack ($num)');
	}
}

// 基底 enum match 用
enum BoxEnum {
	BoxA;
	BoxB;
	BoxC;
}

/**
	具備 1. enum match 與 2. 對應實作某介面資料。
**/
// @:forward
enum abstract AbsBoxEnum(BoxEnum) from BoxEnum to BoxEnum {
	private static var dataArr: Array<BoxData> = [{num: 1}, {num: 1}, {num: 1}];

	inline var AbsBoxA = BoxA;
	inline var AbsBoxB = BoxB;
	inline var AbsBoxC = BoxC;

	public var data(get, never): IBox;

	inline function get_data(): IBox {
		return dataArr[Type.enumIndex(this)];
	}

	@:to
	public inline function toInterface(): IBox {
		return data;
	}
}

/**
	# 種類 B : 

	阿不思 包 enum (不含 associated value)。
**/ //

/**
	基底類別 (無 associated value)
**/
enum MyFruitEnum {
	Apple;
	Banana;
	Plum;
}

/**
	阿不思包 enum
**/
@:forward
enum abstract AbstFruit(MyFruitEnum) from MyFruitEnum to MyFruitEnum {
	public inline var AbsApple = MyFruitEnum.Apple;
	public inline var AbsBanana = MyFruitEnum.Banana;
	public inline var AbsPlum = MyFruitEnum.Plum;
	public inline var AbsPlum2 = MyFruitEnum.Plum;
}

/**
	# 種類 C : 

	阿不思包 primitive type。
**/ //

/**
	阿不思(Int)
**/
enum abstract AbsInt(Int) from Int to Int {
	var Zero = 0;
	var One = 1;
	var Two = 2;
	var AnotherTwo = 2; // 背後同樣值會覆蓋，因為阿不思不存在。
}

// ---------------

class EnumCompareTest {
	public function new() {}

	public function run() {
		trace('==== testEnWrapComp =====');
		testEnWrapComp();
		trace('==== testAbstEnum =====');
		testAbstEnum();
		trace('==== testAbsPri =====');
		testAbsPri();
	}

	// -----------------

	private function testEnWrapComp() {
		var abArr: Array<AbsBoxEnum> = [BoxA, BoxB, BoxC];

		for (ab in abArr) {
			// 可透過阿不思的基底enum來match。
			switch (ab : BoxEnum) {
				case BoxA:
					// 可根據阿不思基底enum來取得對應的 data。
					trace('Found $ab : ${ab.data}');
				case _:
					trace('Not BoxA. It\'s $ab : ${ab.data}');
			}

			// 透過 `@:to 介面` 達到代理效果。 所以這裡可以直接丟 ab。 (會叫用 ab.toInterface())
			// 沒有的話會變成要丟 ab.data。
			tryUnpak(ab.data);
		}
	}

	// 一個吃特定介面的方法。
	private function tryUnpak(boxlike: IBox): Void {
		boxlike.unpack();
	}

	private function testAbstEnum() {
		var fArr: Array<AbstFruit> = [Apple, Banana, Plum, AbsPlum2];

		for (fruit in fArr) {
			// 要轉型為基底才能 match
			/**
				可以用
				`switch (fruit : MyFruitEnum) {}`
				`switch cast(fruit, MyFruitEnum) {}`
				`switch (cast fruit) {}`

				前兩個同意思，但最後的cast是轉 Dynamic 有效能問題。
			**/
			switch (fruit : MyFruitEnum) {
				case Apple:
					trace('apple');
				case Banana:
					trace('banana');
				case Plum:
					// AbsPlum2 綁的也是 Plum，所以會被丟到這裡。
					trace('plum');
			}
		}
	}

	private function testAbsPri() {
		var aiArr: Array<AbsInt> = [AbsInt.Zero, AbsInt.One, AbsInt.Two, AbsInt.AnotherTwo];

		for (nObj in aiArr) {
			// 阿不思(primitive type) 可以直接比對。
			switch (nObj) {
				case Zero:
					trace('Zero $nObj');
				case One:
					trace('One $nObj');
				case Two:
					trace('Two $nObj');
					// 會被覆蓋，編譯期錯誤。
					// case AnotherTwo:
					// 	trace('AnotherTwo $nObj');
			}
		}
	}
}
