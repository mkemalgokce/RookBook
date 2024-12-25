// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import XCTest

final class StringConvertibleTests: XCTestCase {
    func test_string() {
        let anyString = "Hello, World!"
        XCTAssertEqual(anyString.stringValue, anyString)
    }

    func test_int() {
        let anyInt = 42
        XCTAssertEqual(anyInt.stringValue, String(anyInt))
    }

    func test_double() {
        let anyDouble = 42.0
        XCTAssertEqual(anyDouble.stringValue, String(anyDouble))
    }

    func test_url() {
        let anyURL = anyURL()
        XCTAssertEqual(anyURL.stringValue, anyURL.absoluteString)
    }

    func test_uuid() {
        let anyUUID = UUID()
        XCTAssertEqual(anyUUID.stringValue, anyUUID.uuidString)
    }
}
