// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

struct DecodableResourceResponseMapper<Resource: Decodable>: ResponseMapping {
    // MARK: - Nested Types
    enum Error: Swift.Error {
        case invalidData
    }

    // MARK: - Properties
    private let decoder: JSONDecoder
    private let validStatusCodes: Range<Int>

    // MARK: - Initializers
    init(decoder: JSONDecoder = JSONDecoder(), validStatusCodes: Range<Int> = 200..<300) {
        self.decoder = decoder
        self.validStatusCodes = validStatusCodes
    }

    // MARK: - Internal Methods
    func map(data: Data, from response: HTTPURLResponse) throws -> Resource {
        guard validStatusCodes
            .contains(response.statusCode), let decoded = try? decoder.decode(Resource.self, from: data) else {
            throw Error.invalidData
        }
        return decoded
    }
}
