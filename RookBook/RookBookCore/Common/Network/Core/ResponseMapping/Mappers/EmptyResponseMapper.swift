// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

struct EmptyResponseMapper: ResponseMapping {
    // MARK: - Nested Types
    struct InvalidResponseError: Error {}

    // MARK: - Properties
    let validStatusCodes: Range<Int>

    // MARK: - Initializers
    init(validStatusCodes: Range<Int> = 200..<300) {
        self.validStatusCodes = validStatusCodes
    }

    // MARK: - Internal Methods
    func map(data: Data, from response: HTTPURLResponse) throws {
        guard response.hasValidStatusCode(in: validStatusCodes) else {
            throw InvalidResponseError()
        }
    }
}
