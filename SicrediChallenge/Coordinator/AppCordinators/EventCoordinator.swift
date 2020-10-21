//
//  EventCoordinator.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 19/10/20.
//

import Foundation
import UIKit

class EventCoordinator: Coordinator {
    
    weak var parentCoordinator: MainCoordinator?

    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let tabController = UITabBarController()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start(eventListViewModel:  EventListViewModel) {
        let vc =  ViewController.instantiate("Main", id: "home")
        vc.viewModel = eventListViewModel
        vc.coordinator = parentCoordinator
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToEventDetails(for viewModel: EventViewModel) {
        let vc = EventDetailsViewController.instantiate("EventDetails",  id: "EventDetails")
        vc.coordinator = parentCoordinator
        vc.eventViewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }

    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
}
