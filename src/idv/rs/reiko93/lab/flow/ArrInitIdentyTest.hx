package idv.rs.reiko93.lab.flow;

class ArrInitIdentyTest {
	public function new() {}

	public function run() {
		testArrInit();
	}

	// -----------

	function testArrInit() {
		// 在 array 中透過 for 的方式當地初始，相當於用 for 迴圈每次初始一個新的物件。
		var arr1: Array<IdBox> = [for (i in 0...9) {name: "none"}];
		var arr2: Array<Fruit> = [for (i in 0...9) new Fruit()];
		/**
			// Haxe 的 `Array Comprehension (陣列推導式)`，相當於:
			var arrX: Array<Fruit>() = [];
			for (i in 0...9) {
				arrX.push( new Fruit()); // 每次都給一個新初始的物件。
			}
				
			// Java 1.2 的 
			// Arrays.fill(arrX, new Fruit());
			// > 會每一格塞 `同一個` 物件。
			// Java 8 後有 
			// Arrays.setAll(arrX, i -> new Fruit());
			// > 這個才能透過生成函數動態賦值。

			// 不過 Haxe 看來沒這問題。
		**/

		// 這樣指定會使得陣列內美的都指向同一物件。
		var bx: IdBox = {name: 'mybox'};
		var arr3: Array<IdBox> = [for (i in 0...9) bx];
		var apple = new Fruit('apple');
		var arr4: Array<Fruit> = [for (i in 0...9) apple];

		// --------

		var cnt1 = containsSameRef(arr1);
		trace('test[1] same ref count =$cnt1');

		var cnt2 = containsSameRef(arr2);
		trace('test[2] same ref count =$cnt2');

		var cnt3 = containsSameRef(arr3);
		trace('test[3] same ref count =$cnt3');

		var cnt4 = containsSameRef(arr4);
		trace('test[4] same ref count =$cnt4');
	}

	private function containsSameRef(arr: Array<Any>): Int {
		var sameCount: Int = 0;
		for (i in 0...arr.length) {
			for (j in 0...arr.length) {
				if (i == j) {
					continue;
				}
				if (arr[i] == arr[j]) {
					sameCount++;
				}
			}
		}

		return sameCount;
	}
}

@:structInit
private class IdBox {
	var name: String;
}

private class Fruit {
	var name: String;

	public function new(?name: String) {
		if (name != null) {
			this.name = name;
		} else {
			this.name = "unknow";
		}
	}
}
