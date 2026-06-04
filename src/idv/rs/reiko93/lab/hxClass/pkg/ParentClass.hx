/**
	ParentClass.hx
	Reiko93'

	Created by Rahnoc on 2026/05/21.
**/

package idv.rs.reiko93.lab.hxClass.pkg;

/**
	父類別
**/
class ParentClass {
	var name: String;

	public function new(name: String) {
		Sys.println(' > 1. 父類別初始');
		this.name = name;
		// 初始時這樣做事有時很危險的。
		initData();
	}

	public function talk(message: String) {
		Sys.println('$name: $message');
	}

	// 這東西可能被過載。 應該用final鎖住。
	public function initData() {
		Sys.println('父類別初始資料庫中');
		// 應該將必須動作，與擴充可能分離。
		// > 必須的在這裡用 final method 鎖住。
		// > 可擴充的 method 才讓字類別去過載。
	}

	// public func onIninExt() {  }
}
