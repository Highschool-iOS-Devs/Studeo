//
//  Categories.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Categories: Identifiable {
    var id: String
    var name: String
    var count: Int
    
    init(id: String, name: String, count: Int) {
        self.id = id
        self.name = name
        self.count = count
    }
}
