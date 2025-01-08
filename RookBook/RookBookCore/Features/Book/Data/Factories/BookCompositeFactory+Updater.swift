// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

extension BookCompositeFactory {
    // MARK: - Public Methods
    func makeRemoteWithLocalFallbackUpdater(item: Book) -> AnyPublisher<Void, Error> {
        let remoteUpdater = makeRemoteUpdater(item: item)
        let localUpdater = makeLocalUpdater(item: item)

        return remoteUpdater
            .runAlsoAndFallback(to: localUpdater)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods
    private func makeRemoteUpdater(item: Book) -> AnyPublisher<Void, Error> {
        let url = URL(string: "https://api.example.com/books/\(item.id.uuidString)")!
        let dto = BookDTOMapper.map(item)
        let mapper = EmptyResponseMapper()
        var request = URLRequest(url: url, method: .put)
        request.httpBody = try? JSONEncoder().encode(dto)
        return client
            .perform(request)
            .tryMap(mapper.map)
            .eraseToAnyPublisher()
    }

    private func makeLocalUpdater(item: Book) -> AnyPublisher<Void, Error> {
        localRepository
            .update(LocalBookMapper.map(item))
            .eraseToAnyPublisher()
    }
}
