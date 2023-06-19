//
//  WordListViewModel.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit

protocol WordListViewModel: UITableViewDataSource {
    var tableDataPublisher: Published<[WordTagCellData]>.Publisher { get }
    var isLoadingPublisher: Published<Bool>.Publisher { get }
    var sortingMethodPublisher: Published<SortingMethod>.Publisher { get }
    var errorPublisher: Published<ApplicationError>.Publisher { get }
    var sortingMethod: SortingMethod { get }

    func toggleSortingMethod()
    func registerCellsFor(tableView: UITableView)
}
