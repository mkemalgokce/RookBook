// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public final class ImageDataLoaderFactory {
    // MARK: - Properties
    private let client: HTTPClient
    private let imageStore: AnyStorable<LocalData, URL>
    private let scheduler: AnyDispatchQueueScheduler

    // MARK: - Initializers
    public init(client: HTTPClient, imageStore: AnyStorable<LocalData, URL>, scheduler: AnyDispatchQueueScheduler) {
        self.client = client
        self.imageStore = imageStore
        self.scheduler = scheduler
    }

    public func makeLocalImageLoaderWithRemoteFallback(url: URL) -> AnyPublisher<Data, Error> {
        let localImageLoader = LocalRepository(store: imageStore)

        return localImageLoader
            .fetch(with: url)
            .map(\.data)
            .fallback(to: { [client, scheduler, imageStore] in
                client
                    .perform(url.request())
                    .tryMap(DataResponseMapper().map)
                    .caching(to: imageStore, map: { LocalData(id: url, data: $0) })
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}
