// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation
import RookBookCore

final class HTTPClientSpy: HTTPClient {
    // MARK: - Properties
    var requests: [URLRequest] {
        messages.map(\.request)
    }

    var messages: [(request: URLRequest, subject: PassthroughSubject<HTTPClient.Output, Error>)] = []
    private(set) var cancelledRequests = [URLRequest]()

    // MARK: - Internal Methods
    func perform(_ request: URLRequest) -> AnyPublisher<HTTPClient.Output, any Error> {
        let subject = PassthroughSubject<HTTPClient.Output, Error>()
        messages.append((request, subject))
        return subject.eraseToAnyPublisher()
    }

    func complete(withError error: Error, at index: Int = 0) {
        messages[index].subject.send(completion: .failure(error))
    }

    func complete(with data: Data, and response: HTTPURLResponse, at index: Int = 0) {
        messages[index].subject.send((data, response))
        messages[index].subject.send(completion: .finished)
    }

    func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
        guard let url = messages[index].request.url else { return }
        let response = HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: nil)!
        complete(with: data, and: response, at: index)
    }
}
