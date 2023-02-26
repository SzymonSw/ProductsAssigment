//
//  main.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 26/02/2023.
//

import Foundation
import UIKit

private func appDelegateClassName() -> String {
    let isTesting = NSClassFromString("XCTestCase") != nil
    return NSStringFromClass(isTesting ? UnitTestsAppDelegate.self : AppDelegate.self)
}

UIApplicationMain(
    CommandLine.argc,
    CommandLine.unsafeArgv,
    nil,
    appDelegateClassName()
)
