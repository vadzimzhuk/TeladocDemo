//
//  DataProvider.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import Foundation

protocol DataProviderService: MusicAlbumsProvider, TextProvider {}

protocol TextProvider {
    func getSourceText() async throws -> String
}

final class DataProvider {
    private let storageService: StorageService
    private let networkService: NetworkService

    init(storageService: StorageService, networkService: NetworkService) {
        self.storageService = storageService
        self.networkService = networkService
    }
}

extension DataProvider: DataProviderService {
    func getAlbums(for author: String) -> AnyPublisher<API.ITunes.Search.Request.SuccessType, ApplicationError> {
        networkService.getAlbums(for: author)
    }

    func getSourceText() async throws -> String {
            let string = try await storageService.getSourceText()
            return string
    }
}

import Combine

protocol MusicAlbumsProvider {
    func getAlbums(for author: String) -> AnyPublisher<API.ITunes.Search.Request.SuccessType, ApplicationError>
}
