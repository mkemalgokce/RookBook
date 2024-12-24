// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation
import Combine

public protocol HTTPClient {
    typealias Output = (Data, HTTPURLResponse)
    func perform(request: URLRequest) -> AnyPublisher<Output, Never>
}
