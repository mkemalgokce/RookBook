// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

extension Publisher {
    public func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>)
        -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }
}
