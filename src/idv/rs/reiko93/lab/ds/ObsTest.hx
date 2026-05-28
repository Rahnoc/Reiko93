package idv.rs.reiko93.lab.ds;

using idv.rs.reiko93.lab.ds.Observables;

/**
 * 測試 observer 與 observables。
 * 可被觀測的物體，能註冊多位觀測者。
 */
class ObsTest {
	public function new() {}

	public function run() {
		trace('ob test run:');
		var a = new Watcher();
		var b = new Watched();
		// 註冊一個新觀測者
		b.addObserver(a);
		// 有 setter，值變更時會通知所有觀測者。
		b.number = 3;
	}
}
