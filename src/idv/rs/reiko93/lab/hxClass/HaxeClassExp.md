🧪 Haxe `super()` 之前呼叫方法的跨平台實驗報告 (Lab03)

📝 實驗核心程式碼情境

-   子類別在 `super(name)` 之前，呼叫了父類別與子類別過載的 `talk()` 方法。
-   此時父類別的 `name: String` 與子類別的 `money: Int` 尚未在建構子中被賦值。

---

📊 四大目標平台執行期 (Runtime) 狀態清單

1\. JavaScript (Node.js) 平台

-   **執行結果**：`name` = `undefined` / `money` = `undefined`
-   **底層機制**：
    -   編譯器為了繞過 JavaScript ES6 的 `super` 鐵律，在底層**自動重組了程式碼的執行順序**。
    -   程式碼執行時，變數在 JS 記憶體中尚未進行綁定（Binding），因而呈現 JS 原生的 `undefined` 狀態。

2\. Haxe 直譯器 (eval / `--run`) 平台

-   **執行結果**：`name` = `null` / `money` = `null`
-   **底層機制**：
    -   遵循 Haxe 原生的抽象語義，物件實體化時會預先挖好所有的欄位空間。
    -   在尚未正式賦值前，Haxe 虛擬環境將所有可空的引用與數值型態一律視為標準的 `null`。

3\. HashLink C (HLC) 原生平台

-   **執行結果**：`name` = `null` / `money` = **`0`**
-   **底層機制**：
    -   類別被轉譯為 C 語言的結構體（`struct`），記憶體是一塊連續的硬體格子。
    -   記憶體由 HashLink 分配時會**預先清零（Zero-initialized）**，因此數值型態直接呈現硬體初始值 `0`，而 `String` 則因為指標為 `NULL` 被安全格式化為 `"null"`。

4\. C++ (hxcpp / Clang 編譯) 原生平台

-   **執行結果**：`name` = `null` / `money` = **`0`**
-   **底層機制**：
    -   類別繼承自底層的 `hx::Object`，記憶體在交給構造函數前，會被內建的 **Immix GC** 強制刷成 0。
    -   `int` 佔用固定硬體空間並呈現數值 `0`；`String` 的底層指標雖為 `nullptr`，但觸發了 `hxcpp` 內建的防禦機制，安全返回字串 `"null"` 避免了系統閃退（Segmentation Fault）。

---

💡 終極實驗結論

雖然 Haxe 語法不擋、且各平台皆有強大的 Runtime 防禦工程讓程式不直接崩潰，但未初始化的變數會因平台特性產生 **`undefined` / `null` / `0` 的數值分裂**。在生產環境中，仍應嚴格遵守**「永遠把** `super()` **放在建構子第一行」**的軟體工程合約。
