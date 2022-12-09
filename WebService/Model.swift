//
//  Model.swift
//  StoreApp
//
//  Created by Marcelo de Araújo on 09/12/22.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title: String
}

struct Resource<T> {
    let url: URL
    var method: HttpMethod = .get([])
    var headers: [String: String] = [:]
}