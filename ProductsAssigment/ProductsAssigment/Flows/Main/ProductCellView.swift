//
//  ProductCellView.swift
//  ProductsAssigment
//
//  Created by Szymon Swietek on 24/02/2023.
//

import SwiftUI

struct ProductCellView: View {
    let product: Product
    
    var body: some View {
        HStack {
            HStack {
                Text(product.name)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Price").font(.system(size: 12))
                    Text("\(product.price, specifier: "%.2f")")
                }
            }
       
            Spacer()
            AsyncImage(url: URL(string: product.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
            } placeholder: {
                Color.white
                    .frame(width: 70, height: 70)

            }

        }.contentShape(Rectangle())
    }
}
