// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class URL_RequestTests: XCTestCase {
    func test_getRequest() {
        let url = anyURL()
        let request = url.request()
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, HTTPMethod.get.rawValue)
    }

    func test_postRequest() {
        let url = anyURL()
        let request = url.request(for: .post)
        XCTAssertEqual(request.url, url)
        XCTAssertEqual(request.httpMethod, HTTPMethod.post.rawValue)
    }
}
