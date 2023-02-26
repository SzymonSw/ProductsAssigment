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
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .padding(.top, 10)
            }
            List(viewModel.products) { product in
                ProductCellView(product: product)
                    .onTapGesture {
                        viewModel.onProductTapped(product: product)
                    }
            }
           
            if viewModel.isLoading {
                ProgressView().padding(.bottom, 10)
            } else {
                Button("Refresh") {
                    viewModel.onRefreshTapped()
                }
            }
            if viewModel.isDisplayingCachedData {
                Text("Displaying cached data!")
            }
        }
    }
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}
