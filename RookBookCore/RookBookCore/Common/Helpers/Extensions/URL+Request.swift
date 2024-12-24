// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

// MARK: - URL Request Helpers
extension URL {
    public func request(for httpMethod: HTTPMethod = .get) -> URLRequest {
        var request = URLRequest(url: self)
        request.httpMethod = httpMethod.rawValue
        return request
    }
}
