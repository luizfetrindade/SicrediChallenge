//
//  Coorinator.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 19/10/20.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start(eventListViewModel: EventListViewModel)
}
