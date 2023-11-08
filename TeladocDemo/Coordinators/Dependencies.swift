//
//  Dependencies.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import Foundation
import DIContainer

extension AppCoordinator {
    func setupDependencies() {
        Container.standard.register(type: NetworkService.self, key: "ITunesNetworkService") { _ in ITunesNetworkService() }
        Container.standard.register(type: StorageService.self, key: "FileStorage") { _ in FileStorage(fileName: "Romeo-and-Juliet") }
        Container.standard.register(.dataProviderService) { resolver in
            let storageService = try resolver.resolve(.storageService)
            let networkService = try resolver.resolve(.networkService)
            return DataProvider(storageService: storageService, networkService: networkService)
        }
    }
}

extension InjectIdentifier {
    static var networkService: InjectIdentifier<NetworkService> { .by(type: NetworkService.self, key: "ITunesNetworkService") }
    static var storageService: InjectIdentifier<StorageService> { .by(type: StorageService.self, key: "FileStorage") }
    static var dataProviderService: InjectIdentifier<DataProviderService> { .by(type: DataProviderService.self, key: "DataProvider") }
}
