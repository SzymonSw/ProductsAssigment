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
        VStack(alignment: .leading) {
            Group {
                Text("DetailsView.Price".localized()).font(.system(size: 12))
                Text("\(viewModel.product.price, specifier: "%.2f")")
                    .padding(.bottom, 20)

                Text("DetailsView.Description".localized()).font(.system(size: 12))
                Text(viewModel.product.description)
            }
            .padding(.leading, 10)
       
            GeometryReader { geo in
                AsyncImage(url: URL(string: viewModel.product.imageUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                } placeholder: {
                    Color.white
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geo.size.width)
                        .overlay {
                            ProgressView()
                        }
                }
            }
        }
    }
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
    }
}
