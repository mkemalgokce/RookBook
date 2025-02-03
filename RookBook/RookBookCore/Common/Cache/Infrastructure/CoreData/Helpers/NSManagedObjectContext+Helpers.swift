// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import CoreData

extension NSManagedObjectContext {
    /// Executes a block on the context's queue synchronously and rethrows errors.
    /// - Parameter block: A closure that performs work on the context. It may throw errors.
    /// - Throws: An error thrown from the block, if any.
    public func throwingPerformAndWait<T>(_ block: () throws -> T) throws -> T {
        var result: Result<T, Error>!

        performAndWait {
            do {
                let value = try block()
                result = .success(value)
            } catch {
                result = .failure(error)
            }
        }
        return try result!.get()
    }
}
