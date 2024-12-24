// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    // MARK: - Properties
    private let session: URLSession

    // MARK: - Initializers
    public init(session: URLSession) {
        self.session = session
    }

    // MARK: - Public Methods
    public func perform(_ request: URLRequest) -> AnyPublisher<HTTPClient.Output, Error> {
        session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let response = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                return (data, response)
            }
            .eraseToAnyPublisher()
    }
}
