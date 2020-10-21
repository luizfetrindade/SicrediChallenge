//
//  SceneDelegate.swift
//  SicrediChallenge
//
//  Created by Luiz Felipe Trindade on 17/10/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var coordinator: MainCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let nvController = UINavigationController()
        
        coordinator = MainCoordinator(navigationController: nvController)

        coordinator?.start(eventListViewModel: EventListViewModel())
        
        window = UIWindow(windowScene: scene)
        window?.rootViewController = nvController
        window?.makeKeyAndVisible()
    }
}

