// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

public class LoadResourcePresenter<Resource, View: ResourceView> {
    // MARK: - Typealiases
    public typealias Mapper = (Resource) throws -> View.ViewModel

    // MARK: - Properties
    private let resourceView: View
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView
    private let loader: () -> AnyPublisher<Resource, Error>
    private let mapper: Mapper
    private var cancellable: AnyCancellable?

    // MARK: - Initializer
    public init(resourceView: View,
                errorView: ResourceErrorView,
                loadingView: ResourceLoadingView,
                loader: @escaping () -> AnyPublisher<Resource, Error>,
                mapper: @escaping Mapper) {
        self.resourceView = resourceView
        self.errorView = errorView
        self.loadingView = loadingView
        self.loader = loader
        self.mapper = mapper
    }

    public init(resourceView: View,
                errorView: ResourceErrorView,
                loadingView: ResourceLoadingView,
                loader: @escaping () -> AnyPublisher<Resource, Error>) where View.ViewModel == Resource {
        self.resourceView = resourceView
        self.errorView = errorView
        self.loadingView = loadingView
        self.loader = loader
        mapper = { $0 }
    }

    // MARK: - Methods
    public func load() {
        loadingView.display(.init(isLoading: true))

        cancellable = loader()
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
                    let viewModel = try self.mapper(value)
                    self.resourceView.display(viewModel)
                } catch {
                    self.errorView.display(.error(message: "Mapping Error"))
                }
            }
    }
}

extension LoadResourcePresenter: ImageLoaderPresenter {
    public func requestImage() {
        load()
    }

    public func cancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
