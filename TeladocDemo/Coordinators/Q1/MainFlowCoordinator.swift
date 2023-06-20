//
//  MainFlowCoordinator.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit
import DIContainer

class MainFlowCoordinator: BaseCoordinator {
    @Injected(.dataProviderService)
    var dataProviderService: DataProviderService

    weak var delegate: MainFlowCoordinatorDelegate?

    override func start() {
        let dataSource = WordListModel(dataProvider: dataProviderService)
        let viewController = WordListViewController(
            coordinator: self,
            dataSource: dataSource)
        navigationController.setViewControllers([viewController], animated: true)
    }

    public override func handleAlert(for error: ApplicationError) {
        let alert = UIAlertController(title: "Alert", message: error.message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        navigationController.topViewController?.present(alert, animated: true, completion: nil)
    }
}

protocol MainFlowCoordinatorDelegate: AnyObject {}
