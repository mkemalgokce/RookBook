// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import RookBookCore
import UIKit

public final class OnboardingViewController: ViewController<OnboardingView>, RookBookCore.OnboardingView {
    // MARK: - Properties
    private let pageViewModels: [OnboardingPageViewModel<UIImage>]

    public var onRightButtonTap: (() -> Void)?
    public var onLeftButtonTap: (() -> Void)?
    public var onPageIndexChange: ((Int) -> Void)?
    public var onSetupView: (() -> Void)?

    // MARK: - Initializers
    public init(
        pageViewModels: [OnboardingPageViewModel<UIImage>] = []
    ) {
        self.pageViewModels = pageViewModels
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override public func viewDidLoad() {
        super.viewDidLoad()
        onSetupView?()
        setupCollectionView()
        setupPageControl()
        setupButtonTargets()
    }

    public func displayPage(at index: Int) {
        rootView.pageControl.currentPage = index
        rootView.collectionView.scrollToItem(
            at: IndexPath(item: index, section: 0),
            at: .centeredHorizontally,
            animated: true
        )
        configureActionButtonTitle(forLastPage: index == pageViewModels.count - 1)
    }

    public func configureActionButtonTitle(forLastPage isLastPage: Bool) {
        if isLastPage {
            rootView.setRightButtonToFinish()
        } else {
            rootView.setRightButtonToNext()
        }
    }

    // MARK: - Private Methods
    private func setupCollectionView() {
        rootView.collectionView.delegate = self
        rootView.collectionView.dataSource = self
    }

    private func setupPageControl() {
        rootView.pageControl.numberOfPages = pageViewModels.count
    }

    private func setupButtonTargets() {
        rootView.rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        rootView.previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
    }

    @objc private func rightButtonTapped() {
        onRightButtonTap?()
    }

    @objc private func previousButtonTapped() {
        onLeftButtonTap?()
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    public func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        pageViewModels.count
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    )
        -> UICollectionViewCell {
        let cell: OnboardingCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCell.identifier,
            for: indexPath
        ) as! OnboardingCell
        let viewModel = pageViewModels[indexPath.item]
        cell.configure(title: viewModel.title, subtitle: viewModel.subtitle, image: viewModel.image)
        return cell
    }

    public func collectionView(
        _ collectionView: UICollectionView,
        layout _: UICollectionViewLayout,
        sizeForItemAt _: IndexPath
    )
        -> CGSize {
        collectionView.frame.size
    }

    public func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity _: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let pageIndex = Int(targetContentOffset.pointee.x / scrollView.frame.width)
        onPageIndexChange?(pageIndex)
    }
}

extension OnboardingViewController {
    public func configureTexts(withConfiguration configuration: OnboardingTextConfiguration) {
        title = configuration.title
        rootView.nextButtonTitle = configuration.nextButtonTitle
        rootView.finishButtonTitle = configuration.finishButtonTitle
        rootView.previousButtonTitle = configuration.previousButtonTitle

        rootView.setRightButtonToNext()
    }
}
