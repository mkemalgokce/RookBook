// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import Foundation

public final class OnboardingPresenter {
    // MARK: - Properties
    private let view: OnboardingView
    private let totalPages: Int
    private var currentPageIndex = 0
    private var onCompletion: () -> Void

    // MARK: - Initializers
    public init(
        view: OnboardingView,
        totalPages: Int,
        onCompletion: @escaping () -> Void
    ) {
        self.view = view
        self.totalPages = totalPages
        self.onCompletion = onCompletion
    }

    // MARK: - Static Methods
    public static func makeTextConfiguration() -> OnboardingTextConfiguration {
        OnboardingTextConfiguration(
            title: title,
            nextButtonTitle: nextButtonTitle,
            finishButtonTitle: finishButtonTitle,
            previousButtonTitle: previousButtonTitle
        )
    }

    // MARK: - Public Methods
    public func displayNextPage() {
        if currentPageIndex < totalPages - 1 {
            currentPageIndex += 1
            displayCurrentPage()
        } else {
            onCompletion()
        }
    }

    public func displayPreviousPage() {
        if currentPageIndex > 0 {
            currentPageIndex -= 1
            displayCurrentPage()
        }
    }

    public func updatePage(for index: Int) {
        if index >= 0 {
            currentPageIndex = index >= totalPages ? totalPages - 1 : index
        } else {
            currentPageIndex = 0
        }
        displayCurrentPage()
    }

    // MARK: - Private Methods
    private func displayCurrentPage() {
        view.displayPage(at: currentPageIndex)
    }
}
