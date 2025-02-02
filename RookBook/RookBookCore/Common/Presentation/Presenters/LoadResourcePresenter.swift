// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public class LoadResourcePresenter {
    // MARK: - Properties
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView
    private var cancellable: AnyCancellable?

    // MARK: - Initializer
    public init(errorView: ResourceErrorView,
                loadingView: ResourceLoadingView) {
        self.errorView = errorView
        self.loadingView = loadingView
    }

    // MARK: - Load Methods
    public func load<Resource, View: ResourceView>(on resourceView: View,
                                                   loader: @escaping () -> AnyPublisher<Resource, Error>,
                                                   mapper: @escaping (Resource) throws -> View.ViewModel) {
        loadingView.display(.init(isLoading: true))

        cancellable = loader()
            .handleEvents(receiveCancel: { [weak self] in
                self?.loadingView.display(.init(isLoading: false))
            })
            .dispatchOnMainThread()
            .sink { [weak self] completion in
                guard let self else { return }
                self.loadingView.display(.init(isLoading: false))
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.errorView.display(.error(message: error.localizedDescription))
                }
            } receiveValue: { [weak self] value in
                guard let self else { return }
                do {
                    let viewModel = try mapper(value)
                    resourceView.display(viewModel)
                } catch {
                    self.errorView.display(.error(message: "Mapping Error"))
                }
            }
    }

    public func load<Resource, View: ResourceView>(on resourceView: View,
                                                   loader: @escaping () -> AnyPublisher<Resource, Error>)
        where View.ViewModel == Resource {
        loadingView.display(.init(isLoading: true))

        cancellable = loader()
            .handleEvents(receiveCancel: { [weak self] in
                self?.loadingView.display(.init(isLoading: false))
            })
            .dispatchOnMainThread()
            .sink { [weak self] completion in
                guard let self else { return }
                self.loadingView.display(.init(isLoading: false))
                switch completion {
                case .finished:
                    break
                case let .failure(error):
                    self.errorView.display(.error(message: error.localizedDescription))
                }
            } receiveValue: { value in
                resourceView.display(value)
            }
    }

    public func cancel() {
        cancellable?.cancel()
        cancellable = nil
    }
}
