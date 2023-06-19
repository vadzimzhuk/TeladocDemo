//
//  WordListViewController.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit
import Combine

class WordListViewController: UIViewController {

    private var coordinator: Coordinator?
    private var model: WordListViewModel

    private var isLoading: Bool = false {
        didSet {
            isLoading ? progressIndicatorView.startAnimating() : progressIndicatorView.stopAnimating()
        }
    }

    private var currentSortingMethod: SortingMethod {
        didSet {
            update(sortButton: sortButton, for: currentSortingMethod)
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = model
        model.registerCellsFor(tableView: tableView)
        return tableView
    }()

    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setImage(UIImage(systemName: "arrow.down"), for: .normal)
        button.tintColor = .black
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        update(sortButton: button, for: currentSortingMethod)
        return button
    }()

    private var progressIndicatorView: UIActivityIndicatorView = {
        let progressIndicatorView = UIActivityIndicatorView()
        progressIndicatorView.color = .systemPink
        return progressIndicatorView
    }()

    private var disposeBag = Set<AnyCancellable>()

    init(coordinator: Coordinator? = nil,
         dataSource: WordListViewModel) {
        self.coordinator = coordinator
        self.model = dataSource
        self.currentSortingMethod = dataSource.sortingMethod

        super.init(nibName: nil, bundle: nil)

        bindViewModel(dataSource)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        view.backgroundColor = .systemTeal
        setupSubviews()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressIndicatorView.startAnimating()
    }

    private func bindViewModel(_ model: WordListViewModel) {
        model.sortingMethodPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.currentSortingMethod, on: self)
            .store(in: &disposeBag)

        model.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &disposeBag)

        model.tableDataPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &disposeBag)

        model.errorPublisher
            .dropFirst()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                self?.handleAlert(for: error)
            }
            .store(in: &disposeBag)
    }

    private func handleAlert(for error: ApplicationError) {
        coordinator?.handleAlert(for: error)
    }

    private func setupSubviews() {
        view.addSubview(tableView)
        setupTableView()

        tableView.addSubview(progressIndicatorView)
        setupProgressIndicatorView()

        view.addSubview(sortButton)
        setupSortButton()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true

    }

    private func setupSortButton() {
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        sortButton.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: 0).isActive = true
    }

    private func setupProgressIndicatorView() {
        progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        progressIndicatorView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        progressIndicatorView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        progressIndicatorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        progressIndicatorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }

    @objc
    func sortButtonTapped() {
        model.toggleSortingMethod()
    }

    private func update(sortButton: UIButton, for: SortingMethod) {
        let buttonTitle = "Sort by \(currentSortingMethod.localizedName)"
        sortButton.setTitle(buttonTitle, for: .normal)
    }
}
