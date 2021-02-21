import Foundation

public typealias ErrorHook = (Error) -> Void

public struct CachingResourceLoader {
	let reader = LockingResourceReader()
	let tracker = FileChangeTracker()
	
	func resourceData(for file: URL) throws -> Data {
		if tracker.hasFileChanged(file) {
			reader.refresh(file)
		}
		return reader[file]
	}
}

// MARK: Locking URL:data cache

public typealias LRRKey = URL
public typealias LRRValue = Data
public typealias LRRStore = [URL: Data]

public class LockingResourceReader: LockingCache<LRRKey, LRRValue> {
	var errorHook: ErrorHook? = nil
	
	public override func make(
		_ key: LRRKey, 
		_ store: inout LRRStore
	) -> LRRValue { 
		fetch(key)
	}
	
	public func refresh(_ key: LRRKey) {
		lockAndUpdate {
			$0[key] = fetch(key)
		}
	}
	
	private func fetch(_ key: LRRKey) -> Data {
		do {
			return try Data(contentsOf: key)
		} catch {
			errorHook?(error)
			return Data()
		}
	}
}

// MARK: File modification tracker

public class FileChangeTracker {
	public var errorHook: ErrorHook? = nil
	private var knownDates = [URL: Date]()
	private var lock = DispatchSemaphore(value: 1)
	
	public init() { }
	
	public func hasFileChanged(_ file: URL) -> Bool {
		do {
			let lookup = try modificationDate(for: file)
			let known = knownDates[file]
			defer {
				knownDates[file] = lookup
			}
			if let known = known {
				return lookup > known
			} else {
				return true
			}
		} catch {
			errorHook?(error)
			return false	
		}
	}
	
	private func modificationDate(for file: URL) throws -> Date {
		let attributes = try fileManager.attributesOfItem(atPath: file.path)
		return attributes[.modificationDate] as! Date
	}
}
