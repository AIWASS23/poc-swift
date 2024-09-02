//
//  Enuns.swift
//  TestSwiftData
//
//  Created by marcelodearaujo on 30/08/24.
//

import Foundation

enum Rating: String, CaseIterable, Codable, Identifiable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    var id: String { rawValue }
}

enum Constants {
    static let challengesFilename = "challenges.store"
    static let completionsFilename = "challenges.store"
}
