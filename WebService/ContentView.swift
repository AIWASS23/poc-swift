//
//  ContentView.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

import SwiftUI

struct ContentView: View {
    
    let webservice = Webservice()
    @State private var products: [Product] = []
    
    var body: some View {
        List(products, id: \.id) { product in
            Text(product.title)
        }.onAppear {
            
            let productsResource = Resource<[Product]>(url: .products)
            
            webservice.load(productsResource) { result in
                switch result {
                    case .success(let products):
                        DispatchQueue.main.async {
                            self.products = products
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            print(error)
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}