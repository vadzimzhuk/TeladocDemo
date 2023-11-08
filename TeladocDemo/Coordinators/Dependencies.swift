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
        Container.standard.register(type: StorageService.self, key: "FileStorage") { _ in FileStorage(fileName: "Romeo-and-Juliet") }
        Container.standard.register(.dataProviderService) { resolver in
            let storageService = try resolver.resolve(.storageService)
            return DataProvider(storageService: storageService)
        }
    }
}

extension InjectIdentifier {
    static var storageService: InjectIdentifier<StorageService> { .by(type: StorageService.self, key: "FileStorage") }
    static var dataProviderService: InjectIdentifier<DataProviderService> { .by(type: DataProviderService.self, key: "DataProvider") }
}
