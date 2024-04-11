//
//  SceneDelegate.swift
//  iTunesApp
//
//  Created by Daria on 07.04.2024.
//

import UIKit

class DependencyManager {
    
    static func createSearchNC() -> UIViewController {
        let searchVC   = SearchViewController()
        searchVC.title = "SEARCH"
        return searchVC
    }

    
    static func createNavController() -> UINavigationController {
        let navController = UINavigationController()
        if #available(iOS 15, *) {
            // MARK: Navigation bar appearance
            let navigationBarAppearance = UINavigationBarAppearance()
            navigationBarAppearance.configureWithOpaqueBackground()
            navigationBarAppearance.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor : Resources.Colors.seaBlue!
            ]
            navigationBarAppearance.backgroundColor           = Resources.Colors.blueGrey
            UINavigationBar.appearance().standardAppearance   = navigationBarAppearance
            UINavigationBar.appearance().compactAppearance    = navigationBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            
        }
        navController.viewControllers = [createSearchNC()]
        return navController
    }
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
               window                     = UIWindow(frame: windowScene.coordinateSpace.bounds)
               window?.windowScene        = windowScene
               window?.rootViewController = DependencyManager.createNavController()
               window?.makeKeyAndVisible()
    }
}

