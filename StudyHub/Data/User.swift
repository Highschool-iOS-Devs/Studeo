//
//  User.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI


struct User: Identifiable, Codable, Hashable {
    var id:UUID
    var firebaseID: String
    
    var name: String
    var email: String
    var profileImageURL: URL? 
    
    var interests: [UserInterestTypes]?
    var groups: [String]?
    var recentGroups: [String]?
    var recentPeople: [String]?
    
    var studyHours: [Double]
    var studyDate: [String]
    var all: Double
    var month: Double
    var day: Double
    var description: String
    var isAvailable: Bool
    var finishedOnboarding: Bool?
}

struct BasicUser: Identifiable, Codable {
    var id: String
    var name: String
   
    init(id: String, name: String) {
        self.id = id
        self.name = name
       
    }
}
