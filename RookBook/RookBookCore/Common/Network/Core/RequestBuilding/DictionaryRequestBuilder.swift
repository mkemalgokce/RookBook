// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public enum DictionaryRequestBuilder {
    public static func build(on url: URL,
                             from dict: StringDictionaryConvertible,
                             with method: HTTPMethod,
                             headers: [String: String] = [:]) -> URLRequest {
        var request = url.request(for: method)
        request.httpBody = try? JSONSerialization.data(withJSONObject: dict.toStringDictionary())
        request.allHTTPHeaderFields = headers
        return request
    }
}
