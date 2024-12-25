// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

func anyURL(value: String = "any") -> URL {
    URL(string: "https://\(value)-url.com")!
}

func anyURLRequest(url: URL? = nil) -> URLRequest {
    URLRequest(url: url ?? anyURL())
}

func anyNSError() -> NSError {
    NSError(domain: "Error", code: -1)
}

func anyData() -> Data {
    "any data".data(using: .utf8)!
}

func anyHTTPURLResponse(url: URL? = nil, statusCode: Int = 200, headers: [String: String] = [:]) -> HTTPURLResponse {
    HTTPURLResponse(url: url ?? anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: headers)!
}

func makeJSON(dict: [String: Any]) -> Data {
    try! JSONSerialization.data(withJSONObject: dict)
}

func encode<T: Encodable>(_ value: T) -> Data {
    try! JSONEncoder().encode(value)
}
