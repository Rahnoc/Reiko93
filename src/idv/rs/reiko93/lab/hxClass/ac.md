📊 存取控制（Access Control）終極對照表

在 Haxe 中，**沒有 `protected`**，而且只剩下兩個關鍵字。它們的保護範圍跟傳統語言完全錯位：

| 存取級別 | 在 AS3 / Java / C# 的意思 | 在 Haxe 的真正意思 |
| --- | --- | --- |
| public | 全世界都看得到。 | 全世界都看得到。 |
| protected | 只有子類別看得到，外部看不到。 | (Haxe 沒有這個關鍵字) |
| private | 只有自己看得到，連兒子都看不到。 | 只有自己 + 子類別 +「同一個 Package 的鄰居」看得到。 |

**💡 核心教訓**：Haxe 的 `private` 其實就是 **`protected` + Java 的 `package-private`** 的混合體 \[1.0\]。

---

🕵️ Haxe 存取控制的三大「奇葩特徵」

為了讓你的架構在 Haxe 中 100% 穩定，你只需要記住以下三個 Haxe 獨有的規則：

1\. 兒子看得到老爸的 `private`，但不准動（不准 Override）

這就是我們上一題測出來的核心：

-   子類別可以隨時在 `new()` 裡面寫 `this.myPrivateMethod()`。
-   但只要加上 `override` 就會被編譯器封殺。
-   **架構優勢**：這確保了老爸私底下的工作流程（如 `private function init()`）**絕對不會被兒子攔截**，完美防禦了建構子多態漏洞。

2\. 同一個 Package（鄰居）可以互相看光光（隱含的 Friend Class）

在 Haxe 中，如果你在同一個資料夾（例如都在 `idv.rs.reiko93.lab.hxClass.pkg` 裡）開了兩個不同的類別：`ParentClass`和 `NeighborClass`。

-   即使 `ParentClass` 裡的方法寫了 `private function secret()`。
-   `NeighborClass` **竟然可以直接 `new ParentClass().secret()`** 呼叫它！
-   **原因**：Haxe 認為同一個 Package 內部的類別是一組互相合作的模組（Module），所以內部不互相防備。

3\. 終極武器：如果你想跨資料夾「抓人」，用 `@:allow`

如果你在設計大型架構（DP）時，兩個類別明明在不同的資料夾，但你想實現 C++ 的 **`Friend Class`（友員類別）**效果（例如：只允許 `DataManager` 去存取 `User` 的 private 屬性，其他外人都拒絕）：

haxe

```
package my.model;

// 🔒 雖然是 private，但特別開後門給 my.controller.DataManager 看
@:allow(my.controller.DataManager)
class User {
    private var dbPassword(default, null):String;
}
```

請謹慎使用程式碼。

有了 `@:allow` 標籤，Haxe 就會允許指定的類別跨越 `private` 限制去存取，這在設計封閉型的核心架構時非常好用！

  

Swift 的存取控制級別（Access Control）在概念上，完美對應了你剛剛推導出來的這套 Haxe 機制。

Swift 共有五種存取級別（`open`, `public`, `internal`, `fileprivate`, `private`）\[1.0\]，而你提到的 **`open`**、**`internal`**、**`private`**，正好就是解決「看得到 vs 能不能 override」以及「鄰居互看」的核心鑰匙。

我們直接把 **Swift 的存取設計**與 **Haxe 的現狀**進行 Scannable 的神經網路對接：

---

📊 Swift 與 Haxe 存取級別終極對照表

| Swift 存取級別 | Swift 的核心行為 | Haxe 中對應的行為或語法 |
| --- | --- | --- |
| open | 🟢 全世界都看得到🟢 全世界都可以 override | public(Haxe 預設的 public 就是 open 狀態) |
| public | 🟢 全世界都看得到❌ 不准在模組外被 override | final public(開放讀取，但鎖死繼承樹不准改) |
| internal | 🟢 同一個模組（鄰居）看得到❌ 外部看不到 | private（位於同 package 時）(同 package 的類別可以自由互看) |
| fileprivate | 🟢 只有同一個檔案內看得到 | (Haxe 可透過單一 .hx 檔寫多個類別達成) |
| private | ❌ 只有自己類別的小括號內看得到 | private（配合 @:allow 或獨立 package） |

---

🔍 深入解讀：Swift 的核心思維如何解決 Haxe 的痛點？

💡 1. Swift 的 `public` 其實就是 Haxe 的 `final public`

在 Swift 中，`public` 和 `open` 有一個非常高段的劃分 \[1.0\]：

-   如果你寫 `public class`，別人**只能用你，不能繼承或覆寫你** \[1.0\]。
-   如果你想開放別人繼承並 override，你必須明確寫 **`open class`** \[1.0\]。
-   **架構師共鳴**：這正是你在教訓中總結的精髓！為了防禦建構子漏洞，Swift 的 `public` 預設就內建了「鎖死繼承」的保護。在 Haxe 中，我們必須手工寫 `final public` 才能達到 Swift `public` 的安全強度。

💡 2. Swift 的 `internal`（預設級別）就是 Haxe 的 package 鄰居互看

在 Swift 中，如果你什麼都不寫，預設就是 `internal`（同一個 App 或同一個框架模組內可以互相存取） \[1.0\]。

-   **Haxe 的對應**：這就相當於 Haxe 的 `private` 遇到了「同一個 package 資料夾下的鄰居」\[1.0\]。Haxe 認為既然大家都在同一個子專案的資料夾裡（同一個 module），互相串門子是安全的，因此放開了限制。

---

🎯 結論：你不用加強 Access Control，因為你早就懂了！

你之所以會覺得「好像概念要加強」，是因為 **Haxe 把這三種完全不同的物理邊界，通通塞進了同一個 `private` 關鍵字裡面**：

-   面對子類別，它表現得像 Swift 的 `public`（看得到、不准 override）。
-   面對同 Package 的鄰居，它表現得像 Swift 的 `internal`（大家都是自己人，隨便看）。

而 Swift 則是把這些邊界劃分得像外科手術一樣精準（`open` / `public` / `internal`） \[1.0\]。

現在把這兩門語言的雷達圖對齊後，你在 Haxe 中寫抽象架構時，只要在大腦裡下達 Swift 的指令，就能瞬間寫出最安全的 Haxe 程式碼了：

-   **想寫 Swift 的 `public`（不准別人改）** ➔ 在 Haxe 寫 **`final public`**。
-   **想寫 Swift 的 `internal`（只給專案內部組件聯動）** ➔ 在 Haxe 寫 **`private` 並把檔案集中在同一個 package**。

在 Haxe 中，如果你在宣告變數或方法時**什麼都不寫**（不寫 `public` 也不寫 `private`），Haxe 預設的存取層級就是 **`private`**。 \[[1](https://haxe.org/manual/class-field-visibility.html)\]

這又是一個與 AS3、Java、Swift 截然相反的「奇葩反骨設計」！

-   **AS3 / Java / Swift**：什麼都不寫，預設通常是開放的（AS3 的 `internal`、Java 的 `package-private`、Swift 的 `internal`），對同一個模組/專案都是看得到的。
-   **Haxe**：什麼都不寫，預設就是**最保守的 `private`**。 \[[1](https://community.haxe.org/t/can-i-make-a-class-be-private-to-its-package/2755), [2](https://medium.com/@vino7tech/java-access-levels-exploring-public-private-protected-and-default-7d75a68bafe5), [3](https://haxe.org/manual/class-field-visibility.html)\]

---

📋 Haxe「什麼都不寫」的實戰規則

我們直接用代碼來看 Haxe 的反射動作：

haxe

```
class MyClass {
    // 1. 什麼都不寫
    var id:Int; 
    
    // 2. 什麼都不寫
    function doWork() {} 

    // 3. 明確宣告為 public
    public function hello() {}
}
```

請謹慎使用程式碼。

在編譯器的眼裡，上面的代碼跟下面這段是 **100% 完全等價**的： \[[1](https://haxe.org/manual/class-field-visibility.html)\]

haxe

```
class MyClass {
    private var id:Int; 
    private function doWork(); 
    public function hello() {}
}
```

請謹慎使用程式碼。

---

💡 為什麼 Haxe 預設是 `private`？（編譯器的防禦性哲學）

Haxe 官方之所以選擇「不寫就是 private」，背後的核心思維是**「最小權限原則（Principle of Least Privilege）」**： \[[1](https://haxe.org/manual/class-field-visibility.html)\]

1.  **防禦性程式設計（Defensive Coding）**：  
    Haxe 認為，一個類別內部的變數和輔助方法，預設都不應該隨便暴露給外面的世界。如果你需要開放給外部，你必須**很有自覺地、主動地打上 `public`**。這防止了開發者因為忘記寫修飾詞，而不小心把內部機密（如 `var password`）直接暴露出去的慘劇。
2.  **與你總結的教訓完全接軌**：  
    因為不寫就是 `private`，而 Haxe 的 `private` 又是**鎖死不准子類別 override 的**。  
    這代表：**你在父類別拆分工作方法時，只要懶惰什麼都不寫，這個方法就會自動獲得「防止子類別覆寫、防止建構子漏洞」的安全防護罩！** \[[1](https://haxe.org/manual/class-field-visibility.html), [2](https://medium.com/@programmingsolutions750/public-v-s-private-v-s-protected-v-s-default-access-modifiers-in-java-d6079e5ac0dc)\]

---

⚠️ 一個唯一的例外：介面（Interface）與 Extern

只有在 **`interface`（介面）** 或 **`extern class`** 裡面，因為它們本質上就是拿來對外公開的合約，所以如果你在 interface 裡面宣告方法什麼都不寫，它會自動反轉預設為 **`public`**。一般的類別（`class`）則一律是 `private`。 \[[1](https://haxe.org/manual/lf-externs.html), [2](https://haxe.org/manual/class-field-visibility.html)\]

你原本在大腦裡想著「不寫應該會像 Swift/AS3 那樣變 internal 吧？」結果 Haxe 偏偏要往最保守的 `private` 靠攏。\[[1](https://haxe.org/manual/class-field-visibility.html)\]

這個語法特性的加入，是不是讓你的「教訓二：工作拆分時調整可見度」變得更輕鬆了呢？因為以後你只要連 `private` 都懶得寫，程式碼預設就是最安全的防禦狀態了！
