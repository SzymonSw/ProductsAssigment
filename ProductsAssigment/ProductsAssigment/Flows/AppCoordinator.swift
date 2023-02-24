//
//  AppCoordinator.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import UIKit
import SwiftUI

@MainActor
class AppCoordinator {
    private var mainNav: UINavigationController!
    private var dependencies: AppDependency!

    func startWith(rootNavController: UINavigationController) {
        mainNav = rootNavController
        dependencies = AppDependency(api: ApiProvider(), storage: PersistantStorage())

        let mainViewModel = MainViewModel(dependencies: dependencies, delegate: self)
        let mainViewController = UIHostingController(rootView: MainView(viewModel: mainViewModel))
        mainNav.setViewControllers([mainViewController], animated: false)
    }

    private func pushToDetails(product: Product) {
        let vm = DetailsViewModel(product: product)
        let vc = UIHostingController(rootView: DetailsView(viewModel: vm))
        mainNav.pushViewController(vc, animated: true)
    }  
}

extension AppCoordinator: MainViewDelegate {
    func mainViewWantsToShowDetails(of product: Product) {
        pushToDetails(product: product)
    }
}
