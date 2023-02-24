//
//  AppDelegate.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let mainNav = UINavigationController()
        window?.rootViewController = mainNav
        window?.makeKeyAndVisible()
        appCoordinator = AppCoordinator()
        appCoordinator.startWith(rootNavController: mainNav)

        return true
    }
}
