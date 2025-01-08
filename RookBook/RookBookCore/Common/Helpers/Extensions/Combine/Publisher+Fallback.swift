// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

extension Publisher {
    public func fallback(to fallbackPublisher: @escaping () -> AnyPublisher<Output, Failure>)
        -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher() }.eraseToAnyPublisher()
    }

    public func fallback(to fallbackPublisher: AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        self.catch { _ in fallbackPublisher }.eraseToAnyPublisher()
    }
}

extension Publisher {
    /// Executes the primary publisher, and if it succeeds, also executes the fallback publisher in the background.
    /// If the primary publisher fails, it returns the fallback publisher's output.
    /// - Parameters:
    ///   - fallback: A fallback publisher to execute in case of failure or alongside success.
    /// - Returns: A publisher that emits either the primary publisher's output or the fallback's output if the primary
    /// fails.
    func runAlsoAndFallback<Backup: Publisher>(
        to fallback: Backup
    ) -> AnyPublisher<Output, Failure> where Backup.Output == Output, Backup.Failure == Failure {
        handleEvents(receiveCompletion: { completion in
            if case .finished = completion {
                _ = fallback
                    .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
            }
        })
        .catch { _ in fallback }
        .eraseToAnyPublisher()
    }
}
