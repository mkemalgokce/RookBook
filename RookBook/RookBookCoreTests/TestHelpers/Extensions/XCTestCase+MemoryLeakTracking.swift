// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ object: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak object] in
            XCTAssertNil(
                object,
                "Potential memory leak detected. Instance should have been deallocated.",
                file: file,
                line: line
            )
        }
    }
}
