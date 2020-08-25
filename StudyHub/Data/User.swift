//
//  User.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct User: Identifiable {
    var id: String
    var name: String
    var hours: [Double]
    var hoursDate: [Date]
    var interests: [String]
    var isMentor: Bool
    
    init(id: String, name: String, hours: [Double], hoursDate: [Date], interests: [String], isMentor: Bool) {
        self.id = id
        self.name = name
        self.hours = hours
        self.hoursDate = hoursDate
        self.interests = interests
        self.isMentor = isMentor
        
        
    }
}
