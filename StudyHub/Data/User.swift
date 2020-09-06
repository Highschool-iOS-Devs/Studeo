//
//  User.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct User: Identifiable, Codable {
    var id: UUID
    var name: String
    var email: String
    var image: String?
    var interests: [String]?
    var groups: [String]?
    var recentPepole: [User]?
}

struct BasicUser: Identifiable {
    var id: String
    var name: String
    var count: Int
    init(id: String, name: String, count: Int) {
        self.id = id
        self.name = name
        self.count = count
    }
}
