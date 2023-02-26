//
//  UnitTestsAppDelegate.swift
//  ProductsAssigmentTests
//
//  Created by Szymon Swietek on 26/02/2023.
//

import UIKit

final class UnitTestsAppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.rootViewController = UIViewController()
        window?.makeKeyAndVisible()
        return true
    }
}
