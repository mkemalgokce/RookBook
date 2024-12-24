// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

func anyURL() -> URL {
    URL(string: "https://any-url.com")!
}

func anyURLRequest() -> URLRequest {
    URLRequest(url: anyURL())
}

func anyNSError() -> NSError {
    NSError(domain: "Error", code: -1)
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}
