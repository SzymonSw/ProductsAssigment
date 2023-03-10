//
//  AppCoordinator.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import UIKit
import SwiftUI

@MainActor
final class AppCoordinator {
    private var mainNav: UINavigationController!
    private var dependencies: AppDependency!

    func startWith(rootNavController: UINavigationController) {
        mainNav = rootNavController
        let persistantStorage = PersistantStorage()
        dependencies = AppDependency(api: ApiProvider(persistantStorage: persistantStorage), storage: persistantStorage)

        let mainViewModel = MainViewModel(dependencies: dependencies, delegate: self)
        let mainViewController = UIHostingController(rootView: MainView(viewModel: mainViewModel))
        mainViewController.title = "MainView.Title".localized()
        mainNav.setViewControllers([mainViewController], animated: false)
    }

    private func pushToDetails(product: Model.Product) {
        let vm = DetailsViewModel(product: product)
        let vc = UIHostingController(rootView: DetailsView(viewModel: vm))
        vc.title = "\(product.name)"
        mainNav.pushViewController(vc, animated: true)
    }  
}

extension AppCoordinator: MainViewDelegate {
    func mainViewWantsToShowDetails(of product: Model.Product) {
        pushToDetails(product: product)
    }
}
