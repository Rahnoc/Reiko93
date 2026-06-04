/**
	HaxeVsWorkflowExp.hx
	Reiko93'

	Created by Rahnoc on 2026/05/20.
**/

package idv.rs.reiko93.lab.workflow;

/**
	針對 VS Code 建立 Haxe 專案環境初期，建制的 hxml 與 Makefile 等相關工具，

	::測試進入點
**/
class HaxeVsWorkflowExp {
	/**
	 * 進入點，列印訊息。 並測試參數取得。
	 */
	static function main(): Void {
		// Haxe 內建的 trace，會自動附帶檔名與行號，非常適合除錯
		trace("使用 trace 輸出文字。");

		// 如果只想要純文字，不想要行號，可以使用 Sys.println
		Sys.println("使用 Sys.println 輸出");

		// 取得 CLI 參數
		var args = Sys.args();
		Sys.println("收到的參數有: " + args);

		// printEnvInfo();
	}

	/**
	 * 列印環境變數用。 (測試)
	 */
	static function printEnvInfo(): Void {
		var env = Sys.environment();

		// 印出 keys
		for (key in env.keys()) {
			Sys.println(key);
		}

		// 觀察目標清單
		var targets = ["USER", "HOME", "PATH", "SHELL", "PWD"];

		Sys.println("--- Mac 系統環境變數 ---");
		for (key in targets) {
			if (env.exists(key)) {
				Sys.println('$key = ' + env.get(key));
			}
		}
	}
}
