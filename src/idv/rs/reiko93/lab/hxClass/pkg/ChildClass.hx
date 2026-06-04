/**
	ChildClass.hx
	Reiko93'

	Created by Rahnoc on 2026/05/21.
**/

package idv.rs.reiko93.lab.hxClass.pkg;

/**
	子類別
**/
class ChildClass extends ParentClass {
	var money: Int;
	var dataSize: Int;

	// [DESIGN]
	// 與 Swift 不同， Swift 需要處理好自己，才能初始 super()。且在自己準備好之前，不能用自己的東西。
	// 與 C++/Java/AS 等相同， 劈頭就得初始父類別。 但是什麼都不擋，隨你用，沒準備好的 null 算你倒霉。
	public function new(name: String, money: Int) {
		Sys.println(' > 2. 子類別初始');
		// 子類別搞事的範例：
		// (官方建議別在子類別建構子中叫用過載方法)
		// --------------------
		// 在父類別未初始前叫用父類別方法： prop (name) 尚未給定值。
		super.talk("老子在 super.init 之前說話.");
		// 在父類別未初始前叫用子類別過載方法： 使用到且未初始的(父/子)屬性通通 null。
		talk("兒子在 super.init 之前說話.");
		// --------------------

		super(name);

		// 也能放前面，總之都能亂搞。
		this.money = money;
		this.dataSize = 100;
	}

	// 過載方法
	public override function talk(message: String) {
		Sys.print('[過載] ');
		Sys.println('<重寫> $message 錢=$money');
		// super.talk('$message 錢=$money');
	}

	// 父類別如果建構子叫用 initData，實際叫到的會是這裡這一版。 用到的屬性還沒初始就又要 undefined/0 了。
	public override function initData() {
		Sys.println('[過載] 子類別初始資料庫中 資料大小=$dataSize');
	}
}
