//
//  WordListModel.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit
import Combine

typealias WordTagCellData = (word: String, number: Int)

class WordListModel: NSObject, WordListViewModel {
    private var dataProvider: DataProviderService

    private var sourceText: String = ""

    private let defaultSortingMethod: SortingMethod
    @Published private(set) var sortingMethod: SortingMethod
    @Published private var tableData: [WordTagCellData] = []
    @Published private var isLoading: Bool = false
    @Published var error: ApplicationError = .none

    var errorPublisher: Published<ApplicationError>.Publisher { $error }
    var tableDataPublisher: Published<[WordTagCellData]>.Publisher { $tableData }
    var isLoadingPublisher: Published<Bool>.Publisher { $isLoading }
    var sortingMethodPublisher: Published<SortingMethod>.Publisher { $sortingMethod }

    init(dataProvider: DataProviderService,
         defaultSortingMethod: SortingMethod = .wordFrequency) {
        self.defaultSortingMethod = defaultSortingMethod
        self.sortingMethod = defaultSortingMethod
        self.dataProvider = dataProvider
        super.init()

        loadData()
    }

    private func loadData() {
        isLoading = true
        Task {
            do {
                sourceText = try await dataProvider.getSourceText()
                tableData = prepareDataFrom(text: sourceText)
                isLoading = false
            } catch {
                self.error = error as? ApplicationError ?? .genericError(error)
            }
        }
    }

    private func prepareDataFrom(text: String) -> [WordTagCellData] {
        let words = text.words()
        return wordsToTokens(words)
            .sorted(by: sortingMethod.sorter)
    }

    private func wordsToTokens(_ words: [String]) -> [WordTagCellData] {
        var tokensCollection: [String: Int] = [:]
        words.forEach { word in
            if let number = tokensCollection[word] {
                tokensCollection[word] = number + 1
            } else {
                tokensCollection[word] = 1
            }
        }
        return tokensCollection.map { (key: String, value: Int) in
            (key, value)
        }
    }

    func registerCellsFor(tableView: UITableView) {
        tableView.register(DefaultTableViewCell.self, forCellReuseIdentifier: DefaultTableViewCell.reuseIdentifier)
    }

    func toggleSortingMethod() {
        let sortingMethods = SortingMethod.allCases

        let currentMethodIndex = (sortingMethods.lastIndex(of: sortingMethod) ?? 0) as Int
        let nextMethod: SortingMethod

        if currentMethodIndex < sortingMethods.count - 1 {
            nextMethod = sortingMethods[currentMethodIndex + 1]
        } else {
            nextMethod = sortingMethods.first ?? defaultSortingMethod
        }

        tableData = tableData.sorted(by: nextMethod.sorter)
        sortingMethod = nextMethod
    }
}

extension WordListModel: UITableViewDataSource {
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

        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultTableViewCell.reuseIdentifier, for: indexPath) as? DefaultTableViewCell ?? DefaultTableViewCell()
        let entity = tableData[index]
        cell.setup(with: entity)

        return cell
    }
}
