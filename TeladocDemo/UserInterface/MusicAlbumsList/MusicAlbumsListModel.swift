//
//  MusicAlbumsListModel.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit
import Combine

typealias AlbumCellData = API.ITunes.Search.Item

class MusicAlbumsListModel: NSObject, MusicAlbumsListViewModel {
    private var dataProvider: DataProviderService

    @Published private var tableData: [AlbumCellData] = []
    @Published private var isLoading: Bool = false
    @Published var error: ApplicationError = .none
    var searchTerm: String = "thebeatles"

    var errorPublisher: Published<ApplicationError>.Publisher { $error }
    var tableDataPublisher: Published<[AlbumCellData]>.Publisher { $tableData }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }

    private var searchRequestSubscription: AnyCancellable?
    private var disposeBag = Set<AnyCancellable>()

    init(dataProvider: DataProviderService,
         defaultSortingMethod: SortingMethod = .wordFrequency) {
        self.dataProvider = dataProvider
        super.init()

        loadData(searchTerm: searchTerm)
    }

    private func loadData(searchTerm: String) {
        searchRequestSubscription?.cancel()
        
        isLoading = true

        searchRequestSubscription = dataProvider.getAlbums(for: searchTerm)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] result in
                self?.tableData = result.results
            }
//            .store(in: &disposeBag)
    }

    func registerCellsFor(tableView: UITableView) {
        tableView.register(MusicAlbumTableViewCell.self, forCellReuseIdentifier: MusicAlbumTableViewCell.reuseIdentifier)
    }

    func search(term: String) {
        loadData(searchTerm: term)
    }
}

extension MusicAlbumsListModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

        guard tableData.count > index else {
            assertionFailure()
            error = .dataCorrupted

            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: MusicAlbumTableViewCell.reuseIdentifier, for: indexPath) as? MusicAlbumTableViewCell ?? MusicAlbumTableViewCell()
        let entity = tableData[index]
        cell.setup(with: entity)

        return cell
    }
}
