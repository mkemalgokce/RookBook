// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

extension BookCompositeFactory {
    // MARK: - Public Methods
    func makeRemoteWithLocalFallbackDeleter(id: UUID) -> AnyPublisher<Void, Error> {
        let remoteDeleter = makeRemoteDeleter(with: id)
        let localDeleter = makeLocalDeleter(with: id)

        return remoteDeleter
            .runAlsoAndFallback(to: localDeleter)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods
    private func makeRemoteDeleter(with id: UUID) -> AnyPublisher<Void, Error> {
        let url = URL(string: "https://api.example.com/books/\(id.uuidString)")!
        let mapper = EmptyResponseMapper()
        var request = URLRequest(url: url, method: .delete)
        return client
            .perform(request)
            .tryMap(mapper.map)
            .eraseToAnyPublisher()
    }

    private func makeLocalDeleter(with id: UUID) -> AnyPublisher<Void, Error> {
        localRepository
            .delete(with: id)
            .eraseToAnyPublisher()
    }
}
