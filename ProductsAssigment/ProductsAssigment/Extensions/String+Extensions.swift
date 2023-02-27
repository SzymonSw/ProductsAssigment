//
//  Extensions.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 27/02/2023.
//

import Foundation

extension String {
    func localized(_ bundle: Bundle = .main) -> String {
        if let path = bundle.path(forResource: Bundle.main.preferredLocalizations.first ?? "en", ofType: "lproj"),
           let bundle = Bundle(path: path)
        {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else if let path = bundle.path(forResource: "Base", ofType: "lproj"),
                  let bundle = Bundle(path: path)
        {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
}
