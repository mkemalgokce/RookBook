// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine

extension Publisher {
    public func caching<Store: CacheStorable>(to cache: Store, map: @escaping (Output) -> Store.Item)
        -> AnyPublisher<Output, Failure> {
        handleEvents(receiveOutput: { item in
            let cacheItem = map(item)
            cache.saveIgnoringResults(cacheItem)
        })
        .eraseToAnyPublisher()
    }

    public func caching<Store: CacheStorable>(to cache: Store,
                                              map: @escaping (Output) -> [Store.Item]) -> AnyPublisher<Output, Failure>
        where Output: Sequence {
        handleEvents(receiveOutput: { items in
            cache.saveIgnoringResults(map(items))
        })
        .eraseToAnyPublisher()
    }
}

extension Storable {
    func saveIgnoringResults(_ item: Item) {
        try? save(item)
    }

    func saveIgnoringResults(_ items: [Item]) {
        try? saveAll(items)
    }
}
