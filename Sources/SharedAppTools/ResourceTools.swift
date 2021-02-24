import Foundation

public typealias ErrorHook = (Error) -> Void

public struct CachingResourceLoader {
	let reader = LockingResourceReader()
	let tracker = FileChangeTracker()
	
	func resourceData(for file: URL) throws -> Data {
        do {
            if try tracker.hasFileChanged(file) {
                try reader.refresh(file)
            }
            return try reader.get(file)
        } catch {
            throw error
        }
	}
}

// MARK: Locking URL:data cache

public typealias LRRKey = URL
public typealias LRRValue = Data
public typealias LRRStore = [URL: Data]

public class LockingResourceReader: LockingCacheThrowing<LRRKey, LRRValue> {
	public override func make(_ key: LRRKey, _ store: inout LRRStore) throws -> LRRValue {
        try loadDataFrom(key)
	}
	
	public func refresh(_ key: LRRKey) throws {
        let refresh = try loadDataFrom(key)
        set(key, for: refresh)
	}
	
	private func loadDataFrom(_ key: LRRKey) throws -> Data {
        try Data(contentsOf: key)
	}
}

// MARK: File modification tracker

public class FileChangeTracker {
	private var knownDates = [URL: Date]()
	private var lock = DispatchSemaphore(value: 1)
	
	public init() { }
	
	public func hasFileChanged(_ file: URL) throws -> Bool {
        switch try lockedFetch(file) {
        case let (.some(cached), current):
            return cached < current
        default:
            return true
        }
	}
    
    private func lockedFetch(_ file: URL) throws -> (cached: Date?, current: Date) {
        let current = try modificationDate(for: file)
        
        lock.wait(); defer { lock.signal() }
        let cached = knownDates[file]
        knownDates[file] = current
        
        return (cached, current)
    }
	
	private func modificationDate(for file: URL) throws -> Date {
		let attributes = try fileManager.attributesOfItem(atPath: file.path)
		return attributes[.modificationDate] as! Date
	}
}
