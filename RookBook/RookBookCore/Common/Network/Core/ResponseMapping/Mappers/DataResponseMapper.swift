// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public struct DataResponseMapper: ResponseMapping {
    // MARK: - Nested Types
    struct InvalidResponseError: Error {}

    // MARK: - Properties
    let validStatusCodes: Range<Int>

    // MARK: - Initializers
    public init(validStatusCodes: Range<Int> = 200..<300) {
        self.validStatusCodes = validStatusCodes
    }

    // MARK: - Internal Methods
    public func map(data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.hasValidStatusCode(in: validStatusCodes) else {
            throw InvalidResponseError()
        }

        return data
    }
}
