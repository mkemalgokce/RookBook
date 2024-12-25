// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class URL_RequestHTTPMethodTests: XCTestCase {
    func test_init_get() {
        let request = URLRequest(url: anyURL(), method: .get)
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
    }

    func test_init_post() {
        let request = URLRequest(url: anyURL(), method: .post)
        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
    }

    func test_changeMethod() {
        let getRequest = anyURLRequest().changeMethod(to: .get)
        let request = getRequest.changeMethod(to: .post)
        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
    }
}
