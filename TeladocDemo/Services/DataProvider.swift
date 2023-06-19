//
//  DataProvider.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import Foundation

protocol DataProviderService {
    func getSourceText() async throws -> String
}

final class DataProvider {
    private let storageService: StorageService

    init(storageService: StorageService) {
        self.storageService = storageService
    }
}

extension DataProvider: DataProviderService {
    func getSourceText() async throws -> String {
            let string = try await storageService.getSourceText()
            return string
    }
}
