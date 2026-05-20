# Reiko93' - Haxe Revisited Warm-Up Project

*~ 夢迴2k6, Eclipse ASDT Flashout Ant MTASC FlashDevelop Flex AIR ~*

-----

### 建構說明

執行時，本專案主要針對 .c ， .cpp ， .js 或是 直譯。

*.hxml 建構檔案間，透過使用一個基底 base.hxml 來定義共用部分。

各種case子專案，於其 *.hxml 內 引用 base.hxml 為基底。

- 針對 .c 輸出， hlc 轉譯後，我們透過 Makefile 執行一個可參數化的編譯與連結工具。

    ```
    # 1. C 語言流 (MyExample_hlc.hxml)
    base.hxml
    -main <pkgPath.>MyExample
    -hl out_hlc/MyExample/main.c
    --cmd make run_hlc NAME=MyExample ARGS="123 456"
    ```

- 針對 .cpp 輸出，Haxe 會轉譯後編譯。 Makefile 中僅搬移檔案，與提供 CLI 參數。

    ```
    # 2. C++ 語言流 (MyExample_cpp.hxml)
    base.hxml
    -main <pkgPath.>MyExample
    -cpp out_cpp/MyExample
    --cmd make run_cpp NAME=MyExample ARGS="123 456"
    ```
    
- 針對 .js 輸出，Haxe 會轉譯後編譯。 Makefile 中僅叫用 node.js 啟動，與提供 CLI 參數。

    ```
    # 3. JavaScript 語言流 (MyExample_js.hxml)
    base.hxml
    -main <pkgPath.>MyExample
    -js bin_js/MyExample.js
    --cmd make run_js NAME=MyExample ARGS="123 456"
    ```


- 針對 直譯(intepreter)，因為 --interp 無法給 CLI 參數，所以透過 Makefile 叫用

    ```
    # 4. 直譯流 (MyExample_interp.hxml)
    base.hxml
    --cmd make run_interp NAME=MyExample PKG_PATH="<pkgPath>" ARGS="123 456"
    ```

-----

### 清理(中間)產物

本專案編譯輸出皆已標準化至 out_*/（暫存）與 bin_*/（成品）目錄下，Git 保持全乾淨狀態 (by .gitignore)。

- 可 run task 來清除輸出用的目錄與內容。

    ```
    haxe util_clean_out
    ```

-----

### 新增子測試模組時要做的事

- 需要將 settings.json (workspace版) 內的

    ```
    "haxe.configurations": [ ]
    ```
    
- 根據實際需求加入新的 xbuild/*.hxml

    ```
        ["xbuild/Lab01_workflow_hlc.hxml"],
        ["xbuild/Lab01_workflow_cpp.hxml"],
        ["xbuild/Lab01_workflow_interp.hxml"]
    ```

xbuild 子資料夾目的為將子模組的 hxml 集中。 但是基本還是會引用根目錄下的 base.hxml 來作為 -cp 依據。

- 因為是前端 hxml 叫用根目錄下的 makefile，所以 cwd 之類會改變工作目錄的手段要小心使用。

- 這樣 vs code 左下角選取 *.hxml，或是 CMD+Shift+P 後 "Haxe: Select Configuration" 才有得選 /xbuild 下的 *.hxml。

    - 好處是 ws 頂層東西少。 但是新增一個主題的子專案時，都要手動去修 settings.json (ws版)。

    - 懶得處理了，畢竟是要寫 Haxe 不是來搞**組態設定**。 走火入魔只會召喚出**藍色貨櫃鯨魚**之類的鬼東西。