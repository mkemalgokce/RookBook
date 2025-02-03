// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import UIKit

public final class BookView: UIView, ListTableView {
    // MARK: - UI Properties
    public lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.register(BookCell.self)
        view.refreshControl = refreshControl
        view.separatorStyle = .none
        return view
    }()

    public lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .green1
        return control
    }()

    public lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.tintColor = .green1
        view.color = .green1
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidesWhenStopped = true
        return view
    }()

    private lazy var emptyListView: EmptyBookListView = {
        let view = EmptyBookListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Properties
    public var isTableViewEmpty: Bool {
        get { tableView.isHidden && !emptyListView.isHidden }
        set { newValue ? showEmptyList() : showTableView() }
    }

    // MARK: - Initializers
    public init() {
        super.init(frame: .zero)
        setupView()
        setupLayout()
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

    // MARK: - Private Methods
    private func setupView() {
        addSubview(tableView)
        addSubview(emptyListView)

        tableView.addSubview(loadingIndicator)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),

            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            emptyListView.widthAnchor.constraint(equalTo: widthAnchor, constant: -32),
            emptyListView.centerXAnchor.constraint(equalTo: centerXAnchor),
            emptyListView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        isTableViewEmpty = false
    }

    private func showEmptyList() {
        tableView.isHidden = true
        emptyListView.isHidden = false
    }

    private func showTableView() {
        tableView.isHidden = false
        emptyListView.isHidden = true
    }
}
