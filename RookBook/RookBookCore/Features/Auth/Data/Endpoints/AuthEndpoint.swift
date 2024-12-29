// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public enum AuthEndpoint {
    case login
    case register
    case logout

    var appendingPath: String {
        "auth"
    }

    public func url(baseURL: URL) -> URL {
        let url = baseURL.appendingPathComponent(appendingPath)
        switch self {
        case .login:
            return url.appendingPathComponent("login")
        case .register:
            return url.appendingPathComponent("register")
        case .logout:
            return url.appendingPathComponent("logout")
        }
    }
}
