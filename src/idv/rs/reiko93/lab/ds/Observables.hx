package idv.rs.reiko93.lab.ds;

///
/// Observables.hx
/// Reiko93'
///
/// Created by Rahnoc on 2026/05/28.
///
//
// * 官網給的垃圾範例⋯⋯ 不該幹的全幹了，有夠難修。 媽的寫 haxe 教學手冊(beginner)的怎麼全是此等強者？
//
// 為了讓不能多重繼承的 Watched，能因為也是 {}，而能使用Observables的靜態方法。
// 雖然點語法不能自己裡面用，但是 this. 可以叫用。
// > 最好別這樣幹 (寫在與引用的定義檔同一個檔案裡 + {} 什麼物件都能用)，不知哪冒出的遞迴參照會弄死你。
// > 像是 Map 的 []， set型的沒事，get型的疑神疑鬼一路 recursive下去。 跑會過，但是存檔後檢查會雞婆報錯。
// >> 同檔案最好別用using
using idv.rs.reiko93.lab.ds.Observables;

/**
 * 原本範例是針對 3.4.7
 * {} （空匿名結構）只能代表「物件」。 「匿名結構」或「物件實例」。
 * String 在靜態平台是基本型別，不能視為 {}。 在動態平台 JS 有時可能可以但是要賭。
 * > String 最好視為不是 {}。
 * 
 * {} 可以代表的型別（物件 / 參照型別）只要該型別在底層是一個「帶有屬性或方法的物件實體（Object Instance）」，
 * 它就可以被當作 {}。
 * 
 * - 匿名結構（Anonymous Structures）：例如 { name: "Alice", age: 20 }。
 * - 類別實例（Class Instances）：你自己用 new MyClass() 建立的任何物件。
 * - 陣列與字典：Array、Map 等標準庫物件。
 * 
 * > 原因：Haxe 的結構化型別系統（Structural Subtyping）規定，如果型別 A 包含了型別 B 的所有欄位，
 * > A 就可以賦值給 B。因為 {} 裡面有 0 個欄位，而任何物件都至少擁有 0 個以上的欄位，
 * > 所以「任何物件」都能完美相容於 {}。
 * 
 * - Any：可以代表 數字、字串、布林值、物件（全包）。
 * - {} ：只允許代表 物件（排除數字、布林值、靜態平台的字串）。
 */
interface Observer {
	public function notified(sender: IObservableSubject, ?data: Any): Void;
}

// 本來是用typedef AnyObj = {}; 。 反正主要問題不在這裡。
interface IObservableSubject {}

class Observables {
	static private var observables: Map<IObservableSubject, Array<Observer>> = new Map();

	static public function addObserver(subject: IObservableSubject, observer: Observer) {
		if (!observables.exists(subject))
			observables[subject] = new Array<Observer>();
		// > using 加上 observables[subject] get方式會造成recursive 錯誤。
		// observables[subject].push(observer);
		observables.get(subject).push(observer);
	}

	static public function notify(subject: IObservableSubject, ?data: Any) {
		if (observables.exists(subject))
			// > 這裡也是會有recursive 錯誤。
			// for (obs in observables[subject]
			for (obs in observables.get(subject))
				obs.notified(subject, data);
	}
}

class Watcher implements Observer {
	public function new() {}

	public function notified(sender: IObservableSubject, ?data: Any) {
		trace("I was notified with : " + data);
	}
}

// 這裡沒使用繼承 Obervables，因為寫範例的說可能已經繼承其他東西，所以沒位置。
// > haxe 沒有多重繼承
// > 不然用interface + composite 也能解。
// 才會想到用 using 去硬塞 (透過using使得只有本檔案內生效) (透過針對 {} 什麼物件都能接)。
//
// 如果是 typedef AnyObj = {}; 就不用 implement，using 是看你也是 {} 就默認開始偷塞。
// 改成介面這裡就要去實作，不然 using 不認。
class Watched implements IObservableSubject {
	public var number(default, set): Int = 1;

	private function set_number(v: Int) {
		number = v;
		// using 就只為了 notify("hello"); 然後目前版本還不能用，必須補打 this.。搞屁！？
		this.notify("hello");
		// 靜態方法要加this，不然會以為是 "hello"字串在叫用，當然 "hello" 沒有註冊swatcher，是 b 才有。
		// > 然後data字串還是 null。
		// > 官網這範例編譯環境是還在用 Haxe 3.4.7，所以沒加 this 給過。
		// Observables.notify(this, "Ellow~");
		return number;
	}

	public function new() {}
}
