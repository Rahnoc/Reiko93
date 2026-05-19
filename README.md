# Reiko93' - Haxe Revisited Warm-Up Project

~ 夢迴2k6, Eclipse ASDT Flashout Ant MTASC FlashDevelop Flex AIR ~

-----

### 建構說明

執行時，本專案主要針對 .c ， .cpp 或是 直譯。

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

- 針對 直譯(intepreter)，因為 --interp 無法給 CLI 參數，所以透過 Makefile 叫用

    ```
    # 3. 直譯流 (MyExample_interp.hxml)
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
