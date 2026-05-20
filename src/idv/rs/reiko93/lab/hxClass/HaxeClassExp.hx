package idv.rs.reiko93.lab.hxClass;

///
/// HaxeClassExp.hx
/// Reiko93'
///
/// Created by Rahnoc on 2026/05/20.
///
import idv.rs.reiko93.lab.hxClass.pkg.*;

/**
 * 類別初始實驗
 * ::測試進入點
 */
class HaxeClassExp {
	public static function main() {
		Sys.println("hello");
		classInitTest();
	}

	// 實驗點有兩個：
	// 1. 子類別建構子內在叫用 super() 之前亂叫一通，會碰到一堆未初始的東西。
	// 2. 父類別建構子內叫用方法，該方法在子類別中被過載。
	//    子類別的 super() 內會去叫過載版本，而此時過載版若用到子類別中尚未初始的資料就⋯⋯
	static function classInitTest() {
		var p: ParentClass = new ParentClass("Homa");
		var c: ChildClass = new ChildClass("Batz", 50);

		p.talk("我是老爸.");
		c.talk("兒子在這.");
	}
}

// 教訓：
// super() 擺第一行
// 建構子工作拆分時，記得調整可見度，或是用final鎖住。
