//
//  MainCoordinator.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 19/10/20.
//


import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - LoginCoordinator
    func start(eventListViewModel: EventListViewModel) {
        let child = EventCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.start(eventListViewModel: eventListViewModel)
    }
    
    func goToEventDetails(for viewModel: EventViewModel) {
        let child = EventCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.parentCoordinator = self
        child.goToEventDetails(for: viewModel)
    }
    
    // MARK: - Global Coordinator
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    // MARK: - Common
    func removeAllChild() {
        childCoordinators.removeAll()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        if let homeViewController = fromViewController as? HomeViewController {
            childDidFinish(homeViewController.coordinator)
        }
    }
}

