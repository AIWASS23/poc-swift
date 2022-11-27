//
//  Model.swift
//  PocCustomCellWithUICollectionView
//
//  Created by Marcelo De Araújo on 24/11/22.
//

import Foundation
import UIKit

enum Section {
    case main
}

enum ListItem: Hashable {
    case header(HeaderItem)
    case symbol(SFSymbolItem)
}

struct HeaderItem: Hashable {
    let title: String
    let symbols: [SFSymbolItem]
}

struct SFSymbolItem: Hashable {
    let name: String
    let image: UIImage

    init(name: String) {
        self.name = name
        self.image = UIImage(systemName: name)!
    }
}
