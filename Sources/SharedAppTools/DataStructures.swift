import Foundation

// MARK: Locking Cache
protocol CacheBuilder {
	associatedtype Key: Hashable
	associatedtype Value
	func make(_ key: Key, _ store: inout [Key: Value]) -> Value
}

/// Returns reads immediately, and if no value exists, locks dictionary write
/// and creates a new object from the given builder. Passed map to allow additional
/// modifications during critical section
open class LockingCache<Key: Hashable, Value>: CacheBuilder {
	private var cache = [Key: Value]()
	private let semaphore = DispatchSemaphore(value: 1)
	
	public init() { }
	
	public subscript(key: Key) -> Value {
		get { cache[key] ?? lockAndCache(key) }
		set { lockAndUpdate { $0[key] = newValue } }
	}
	
	public func lockAndUpdate(_ action: (inout [Key: Value]) -> Void) {
		lock(); defer {unlock() }
		action(&cache)
	}
	
	open func make(_ key: Key, _ store: inout [Key: Value]) -> Value {
		fatalError("Must conform to make")
	}
}

private extension LockingCache {
	private func lock() { semaphore.wait() }
	private func unlock() { semaphore.signal() }
	
	/// Wait and recheck cache, last lock may have already set
	private func lockAndCache(_ key: Key) -> Value {
		lock(); defer { unlock() }
		return cache[key] ?? makeFor(key)
	}
	
	/// Create and set, default result as cache value
	private func makeFor(_ key: Key) -> Value {
		let new = make(key, &cache)
		cache[key] = new
		return new
	}
}
