#
# 多功能 Makefile for Haxe
# Reiko93'
# Created by Rahnoc on 2026/05/19
#

# 針對 haxelib.Hashlink(C 模式) 與 hxcpp(C++ 模式) 與 Haxe 直譯(Interpreter)的建置引擎
# > 針對 haxelib.Hashlink 轉譯的 .c，再透過 clang 編譯，加上 Homebrew.Hashlink 連結出執行檔。
# > hxcpp 自己會搞定，直接輸出執行檔。這裡只有搬檔案。
#
# 中繼檔目錄 /out_<目標種類>，會根據子專案開子資料夾。 (就是out_*/下會有資料夾)
# > 子專案生成的中繼檔會放進 /out_hlc/<LabMainName>/，不會大家混在一起。
#
# 支援 C 目標寫入 bin_hlc，C++ 目標寫入 bin_cpp。
# > /bin_<目標種類>/ 各個子專案的執行檔會放在一起。
#
# 之後可以執行 (附CLI參數)。


# 預設變數（未傳入時有預設值）
NAME ?= Main
ARGS ?= 
# 基礎 Package 路徑配置 (aaa.bbb.cc 逗號分隔)
PKG_PATH ?=

# 判斷 URL 與 NDX 串接是否中間要補逗號。
ifeq ($(strip $(PKG_PATH)),)
    # 情況 A：PKG_PATH 為空，-main 直接指定檔名
    FULL_MAIN = $(NAME)
else
    # 情況 B：PKG_PATH 有值，自動用點號結合
    FULL_MAIN = $(strip $(PKG_PATH)).$(NAME)
endif

# 使用 which 檢查 node 是否存在
NODE_CHECK := $(shell which node 2>/dev/null)


# 根據種類決定執行檔後方贅詞
POST_HLC = _hlc
POST_CPP = _cpp


# 1. HLC (C 語言) 編譯與連結用的參數
BIN_HLC = bin_hlc
OUT_SUB_HLC = out_hlc/$(NAME)
EXE_HLC = $(NAME)$(POST_HLC)
CFLAGS = -O3 -I $(OUT_SUB_HLC) -I /opt/homebrew/include
LDFLAGS = -L /opt/homebrew/lib -lhl


# 2. CPP (C++ 語言) 的歸類資料夾
BIN_CPP = bin_cpp
OUT_SUB_CPP = out_cpp/$(NAME)
EXE_CPP = $(NAME)$(POST_CPP)


# 3. JS (JavaScript) 的輸出資料夾
BIN_JS = bin_js
FILE_JS = $(NAME).js


# ----------------------------------------------------
# 1. HashLink/C (C 模式) 的 Task
# ----------------------------------------------------
# 中繼擋下的所有 .c 都會編譯。
run_hlc:
	mkdir -p $(BIN_HLC)
	clang $(CFLAGS) -o $(BIN_HLC)/$(EXE_HLC) $(OUT_SUB_HLC)/*.c $(LDFLAGS)
	$(BIN_HLC)/$(EXE_HLC) $(ARGS)


# ----------------------------------------------------
# 2. C++ (hxcpp 模式) 的 Task
# ----------------------------------------------------
# Haxe 本身會把執行檔(與<LabMainName>同名)吐在 out_cpp/<LabMainName>/ 裡，我們把它搬移到 bin_cpp/ 並加上後綴_cpp，進行統一歸類
run_cpp:
	mkdir -p $(BIN_CPP)
	mv $(OUT_SUB_CPP)/$(NAME) $(BIN_CPP)/$(EXE_CPP)
	$(BIN_CPP)/$(EXE_CPP) $(ARGS)


# ----------------------------------------------------
# 3. JavaScript (Node.js 執行模式) Task
# ----------------------------------------------------
# 執行使用 Node.js。
run_js:
ifeq ($(NODE_CHECK),)
# 沒裝 Node.js 時執行的區塊
	@echo "=================================================="
	@echo "錯誤: 偵測不到 Node.js 執行環境！"
	@echo "'brew install node' 安裝，或使用瀏覽器開啟。"
	@echo "=================================================="
else
# 有裝 Node.js 時正常執行
	node $(BIN_JS)/$(FILE_JS) $(ARGS)
endif


# ----------------------------------------------------
# Y. 記憶體直譯模式 (Interpreter) Task
# ----------------------------------------------------
# 直譯時會依賴於 base.hxml 來取得如 src 等基本設定。
# 需要 package 路徑。
run_interp:
	haxe base.hxml -main $(FULL_MAIN) --run $(FULL_MAIN) $(ARGS)


# ----------------------------------------------------
# Z. make clean 清除 中繼目錄 與 執行檔輸出目錄 用。
# ----------------------------------------------------
clean:
	rm -rf out_hlc out_cpp $(BIN_HLC) $(BIN_CPP) $(BIN_JS)
