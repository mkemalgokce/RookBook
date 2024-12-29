// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore

final class AppleCredentialsProviderSpy: AppleCredentialsProviding {
    // MARK: - Properties
    private(set) var provideCallCount = 0
    var result: Result<AppleCredentials, Error>?

    // MARK: - Internal Methods
    func provide() -> AnyPublisher<AppleCredentials, any Error> {
        provideCallCount += 1

        if let result {
            switch result {
            case let .success(credentials):
                return Just(credentials)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            case let .failure(error):
                return Fail(error: error).eraseToAnyPublisher()
            }
        }

        return Empty().eraseToAnyPublisher()
    }

    func completeWithSuccess(_ credentials: AppleCredentials) {
        result = .success(credentials)
    }

    func completeWithFailure(_ error: Error) {
        result = .failure(error)
    }
}
