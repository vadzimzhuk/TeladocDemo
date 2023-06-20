//
//  MusicAlbumsListViewModel.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit

protocol TrackableLoading {
    var isLoadingPublisher: Published<Bool>.Publisher { get }
}

protocol MusicAlbumsListViewModel: UITableViewDataSource, TrackableLoading {
    var tableDataPublisher: Published<[AlbumCellData]>.Publisher { get }
    var errorPublisher: Published<ApplicationError>.Publisher { get }

    func registerCellsFor(tableView: UITableView)
}
