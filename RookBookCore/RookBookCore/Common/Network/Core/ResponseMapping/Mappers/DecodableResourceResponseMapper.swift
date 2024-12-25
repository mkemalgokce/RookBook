// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

struct DecodableResourceResponseMapper<Resource: Decodable>: ResponseMapping {
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
        guard validStatusCodes.contains(response.statusCode) else {
            throw URLError(.badServerResponse)
        }

        return try decoder.decode(Resource.self, from: data)
    }
}
