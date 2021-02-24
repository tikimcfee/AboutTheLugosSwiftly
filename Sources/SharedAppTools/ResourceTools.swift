import Foundation

public typealias ErrorHook = (Error) -> Void

public struct CachingLoader {
	let reader = LockingResourceReader()
	let tracker = FileChangeTracker()
    
    public init() { }
	
	public func resourceData(for file: URL) throws -> String {
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

public typealias ResourceKey = URL
public typealias LockedResource = String
public typealias LockedResourceMap = [URL: String]

public class LockingResourceReader: LockingCacheThrowing<ResourceKey, LockedResource> {
	public override func make(_ key: ResourceKey, _ store: inout LockedResourceMap) throws -> LockedResource {
        try loadDataFrom(key)
	}
	
	public func refresh(_ key: ResourceKey) throws {
        let refresh = try loadDataFrom(key)
        set(key, for: refresh)
	}
	
	private func loadDataFrom(_ key: ResourceKey) throws -> LockedResource {
        try String(contentsOf: key)
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
        lock.wait(); defer { lock.signal() }
        
        let current = try modificationDate(for: file)
        let cached = knownDates[file]
        knownDates[file] = current
        
        return (cached, current)
    }
	
	private func modificationDate(for file: URL) throws -> Date {
		let attributes = try fileManager.attributesOfItem(atPath: file.path)
		return attributes[.modificationDate] as! Date
	}
}
