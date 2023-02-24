//
//  DetailsView.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import SwiftUI

struct DetailsView: View {
    @ObservedObject var viewModel: DetailsViewModel

    var body: some View {
        Text("Details")
    }
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
}
