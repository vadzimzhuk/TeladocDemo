//
//  MusicAlbumsListViewController.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit
import Combine

class MusicAlbumsListViewController: UIViewController {

    private var coordinator: Coordinator?
    private var model: MusicAlbumsListViewModel

    private var isLoading: Bool = false {
        didSet {
            isLoading ? progressIndicatorView.startAnimating() : progressIndicatorView.stopAnimating()
        }
    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = model
        model.registerCellsFor(tableView: tableView)
        return tableView
    }()

    private var progressIndicatorView: UIActivityIndicatorView = {
        let progressIndicatorView = UIActivityIndicatorView()
        progressIndicatorView.color = .systemPink
        return progressIndicatorView
    }()

    private var disposeBag = Set<AnyCancellable>()

    init(coordinator: Coordinator? = nil,
         dataSource: MusicAlbumsListViewModel) {
        self.coordinator = coordinator
        self.model = dataSource

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

    private func bindViewModel(_ model: MusicAlbumsListViewModel) {

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
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true

    }

    private func setupProgressIndicatorView() {
        progressIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        progressIndicatorView.widthAnchor.constraint(equalToConstant: 25).isActive = true
        progressIndicatorView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        progressIndicatorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        progressIndicatorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
    }
}
