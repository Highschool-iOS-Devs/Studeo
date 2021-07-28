//
//  SettingsData.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/16/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct SettingsData: Identifiable, Codable {
    var id: UUID
//    var personalInfo: Bool
    var country: String
    var chatNotifications: Bool
    var newGroupNotifications: Bool
    var language: String
    
    init(id: UUID = UUID(), country: String = "US", chatNotifications: Bool = true, newGroupNotifications: Bool = true, language: String = "EN") {
        self.id = id
        self.country = country
        self.chatNotifications = chatNotifications
        self.newGroupNotifications = newGroupNotifications
        self.language = language
    }

}


//
//struct SettingsData: Codable {
//    var settings:[SettingsSubData]
//
//}
//struct SettingsSubData<T:Codable>:Codable{
//    var name:String
//    var field:T
//}
//
////GOAL to create a SettingsData struct where settings contain many SettingsSubData with different type for field property
//
////DOES NOT WORK
//let settings = SettingsData(settings: [SettingsSubData(name: "Country", field: "United States"), SettingsSubData(name: "Notifications", field: true), SettingsSubData(name: "Personal info", field: true)])
