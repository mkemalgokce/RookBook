// Copyright © 2024 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class OnboardingView: UIView {
    // MARK: - UI Properties
    lazy var rightButton: RoundedButton = {
        let button = RoundedButton(title: nextButtonTitle, backgroundColor: .green1, textColor: .white)
        return button
    }()

    lazy var previousButton: RoundedButton = {
        let button = RoundedButton(title: previousButtonTitle, backgroundColor: .green3, textColor: .white)
        return button
    }()

    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .green1
        pageControl.pageIndicatorTintColor = .green3
        return pageControl
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()

    // MARK: - Properties
    var previousButtonTitle: String? = "PREV" {
        didSet {
            previousButton.setTitle(previousButtonTitle, for: .normal)
        }
    }

    var nextButtonTitle: String? = "NEXT"
    var finishButtonTitle: String? = "FINISH"

    // MARK: - Initializers
    init() {
        super.init(frame: .zero)
        setupCollectionView()
        setupBottomBar()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle Methods
    override public func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(colors: [.green3, .green4])
    }

    // MARK: - Internal Methods
    func setRightButtonToNext() {
        rightButton.setTitle(nextButtonTitle, for: .normal)
    }

    func setRightButtonToFinish() {
        rightButton.setTitle(finishButtonTitle, for: .normal)
    }

    func updateRightButtonTitle(title: String) {
        rightButton.setTitle(title, for: .normal)
    }

    // MARK: - Private Methods
    private func setupBottomBar() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [previousButton, rightButton])
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.distribution = .fillEqually
        bottomControlsStackView.spacing = 8
        addSubview(bottomControlsStackView)

        NSLayoutConstraint.activate([
            bottomControlsStackView.bottomAnchor
                .constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            bottomControlsStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16
            ),
            bottomControlsStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16
            ),

            bottomControlsStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 50)
        ])

        addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 16)
        ])
    }

    private func setupCollectionView() {
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.centerXAnchor.constraint(equalTo: centerXAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor),
            collectionView.widthAnchor.constraint(equalTo: widthAnchor),
            collectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6)
        ])

        collectionView.register(
            OnboardingCell.self,
            forCellWithReuseIdentifier: OnboardingCell.identifier
        )
    }
}
