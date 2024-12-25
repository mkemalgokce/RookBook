// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

// MARK: - URLRequest HTTP Method Helpers
extension URLRequest {
    public init(url: URL, method: HTTPMethod) {
        self.init(url: url)
        httpMethod = method.rawValue
    }

    public func changeMethod(to method: HTTPMethod) -> URLRequest {
        var request = self
        request.httpMethod = method.rawValue
        return request
    }
}
