//
//  MainView.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("Main")
            Button {
                viewModel.onProductTapped()
            } label: {
                 Text("Show Details")
            }
        }
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}
