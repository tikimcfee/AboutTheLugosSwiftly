import Foundation

// MARK: Locking Cache
protocol CacheBuilder {
	associatedtype Key: Hashable
	associatedtype Value
	func make(_ key: Key, _ store: inout [Key: Value]) throws -> Value
}

/// Returns reads immediately, and if no value exists, locks dictionary write
/// and creates a new object from the given builder. Passed map to allow additional
/// modifications during critical section.
/// -- Rebuilt to allow errors to be handled instead of defaulted on.
open class LockingCacheThrowing<Key: Hashable, Value>: CacheBuilder {
	private var cache = [Key: Value]()
	private let semaphore = DispatchSemaphore(value: 1)
	
	public init() { }
    
    public func get(_ key: Key) throws -> Value {
        guard let cached = cache[key] else {
            return try lockAndCache(key)
        }
        return cached
    }
    
    public func set(_ key: Key, for value: Value) {
        lock(); defer { unlock() }
        cache[key] = value
    }

    open func make(_ key: Key, _ store: inout [Key: Value]) throws -> Value {
        fatalError("Must conform to make")
    }
}

private extension LockingCacheThrowing {
	private func lock() { semaphore.wait() }
	private func unlock() { semaphore.signal() }
	
	/// Wait and recheck cache, last lock may have already set
	private func lockAndCache(_ key: Key) throws -> Value {
		lock(); defer { unlock() }
        
        if let cached = cache[key] {
            return cached
        } else {
            let new = try make(key, &cache)
            cache[key] = new
            return new
        }
	}
}
