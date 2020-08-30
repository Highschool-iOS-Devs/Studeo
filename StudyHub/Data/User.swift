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
    var image: String
    var fcmToken: String
    var school: [Double]
    //long and lat coordinates
    var hours: [Double]
    var hoursDate: [Date]
    var interests: [String]
    var groups: [String]
    var isMentor: Bool
    var interactedPeople: [String]
    var interactedChatRooms: [String]
    init(id: String, name: String, image: String, fcmToken: String, school: [Double], hours: [Double], hoursDate: [Date], interests: [String], groups: [String], isMentor: Bool, interactedPeople: [String], interactedChatRooms: [String]) {
        self.id = id
        self.name = name
        self.image = image
        self.fcmToken = fcmToken
        self.school = school
        self.hours = hours
        self.hoursDate = hoursDate
        self.interests = interests
        self.groups = groups
        self.isMentor = isMentor
        self.interactedPeople = interactedPeople
        self.interactedChatRooms = interactedChatRooms
    }
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
