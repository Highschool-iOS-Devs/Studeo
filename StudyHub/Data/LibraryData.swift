//
//  LibraryData.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct LibraryData: Identifiable {
    var id: String
    var name: String
    var description: String
    var image: String
    
    
    init(id: String, name: String, description: String, image: String) {
        self.id = id
        self.name = name
        self.description = description
        self.image = image
        
        
    }
}
