//
//  AppCoordinator.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit

class AppCoordinator: BaseCoordinator {

    init() {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        super.init(navigationController: navigationController)

        setupDependencies()
    }

    override func start() {
        startMainFlow()
    }

    private func removeCoordinator(coordinator: BaseCoordinator) {

        var idx: Int?

        for (index, value) in childCoordinators.enumerated() {
            if value === coordinator {
                idx = index
                break
            }
        }

        if let index = idx {
            childCoordinators.remove(at: index)
        }
    }
}

extension AppCoordinator {

    private func startMainFlow() {
        let coordinator = MainFlowCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
    }

}

extension AppCoordinator: MainFlowCoordinatorDelegate {}
