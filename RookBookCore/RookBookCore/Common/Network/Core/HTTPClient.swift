// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public protocol HTTPClient {
    typealias Output = (Data, HTTPURLResponse)
    func perform(_ request: URLRequest) -> AnyPublisher<Output, Error>
}
