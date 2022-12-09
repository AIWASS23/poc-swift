//
//  Model.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

import Foundation

struct Course: Identifiable {
    let id = UUID().uuidString
    
    var name: String
    var duration: String
    var category: String
}