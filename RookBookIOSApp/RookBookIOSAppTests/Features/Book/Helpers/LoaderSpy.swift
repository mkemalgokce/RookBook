// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import RookBookCore
import XCTest

final class LoaderSpy {
    private(set) var loadRequests: [PassthroughSubject<[Book], Error>] = []
    private(set) var loadImageRequests: [(url: URL, publisher: PassthroughSubject<Data, Error>)] = []

    var loadedImageURLs: [URL] {
        loadImageRequests.map(\.url)
    }

    private(set) var cancelledImageURLs = [URL]()

    func loadPublisher() -> AnyPublisher<[Book], Error> {
        let publisher = PassthroughSubject<[Book], Error>()
        return publisher.handleEvents(receiveSubscription: { [weak self] _ in
            self?.loadRequests.append(publisher)
        }).eraseToAnyPublisher()
    }

    func loadImagePublisher(for url: URL) -> AnyPublisher<Data, Error> {
        let publisher = PassthroughSubject<Data, Error>()
        return publisher.handleEvents(receiveSubscription: { [weak self] _ in
            self?.loadImageRequests.append((url, publisher))
        }, receiveCancel: { [weak self] in
            self?.cancelledImageURLs.append(url)
        }).eraseToAnyPublisher()
    }

    func completeLoad(with books: [Book] = [], at index: Int = 0) {
        loadRequests[index].send(books)
        loadRequests[index].send(completion: .finished)
    }

    func completeLoadWithError(at index: Int = 0) {
        loadRequests[index].send(completion: .failure(anyNSError()))
    }

    func completeLoadImage(with data: Data? = anyData(), at index: Int = 0) {
        loadImageRequests[index].publisher.send(data ?? anyData())
        loadImageRequests[index].publisher.send(completion: .finished)
    }

    func completeLoadImageWithError(at index: Int = 0) {
        loadImageRequests[index].publisher.send(completion: .failure(anyNSError()))
    }
}
