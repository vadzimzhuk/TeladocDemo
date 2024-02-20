//
//  Coordinator.swift
//  TeladocDemo
//
//  Created by Vadim Zhuk on 18.06.23.
//

import UIKit

public protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }

    func handleAlert(for error: ApplicationError)
    func start()
}

open class BaseCoordinator: Coordinator {
    open var childCoordinators = [Coordinator]()
    open var navigationController: UINavigationController

    public init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    open func start() { assertionFailure() }
    open func handleAlert(for error: ApplicationError) { assertionFailure() }
}
