package idv.rs.reiko93.lab.ds;

///
/// Maybe.hx
/// Reiko93'
///
/// Created by Rahnoc on 2026/05/28.
///

/**
 * Null safety.
 */
abstract Maybe<T>(Null<T>) from Null<T> to Null<T> {
	public inline function isNotNull(): Bool {
		return this != null;
	}

	// 強制拆包 (!)
	public inline function unwrap(): T {
		return if (isNotNull()) this else throw "Fatal Error";
	}

	// Nil-Coalescing (??)
	public inline function or(def: T): T {
		return if (isNotNull()) this else def;
	}

	// 有值才執行動作 (if let)
	public inline function ifLet(fn: T->Void): Void {
		if (isNotNull()) fn(this);
	}

	// 有值才轉換，保持包裝 (Swift 的 .map)
	public inline function map<S>(fn: T->S): Maybe<S> {
		return if (isNotNull()) fn(this) else null;
	}

	// 轉換並在為空時給予預設值 (map + or 的合體)
	public inline function mapOr<S>(fn: T->S, def: S): S {
		return if (isNotNull()) fn(this) else def;
	}
}
