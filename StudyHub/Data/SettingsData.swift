//
//  SettingsData.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/16/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct SettingsData: Identifiable, Codable {
    var id = UUID()
    var settings:[SettingSubData]
    
    static let defaultSettings = SettingsData(settings: [SettingSubData(name: "Personal info", state: true), SettingSubData(name: "Country", field: "US"), SettingSubData(name: "Chat notifications", state: true), SettingSubData(name: "New group notifications", state: true), SettingSubData(name: "Language", field: "EN")])

}
struct SettingSubData:Codable{
    var name:String
    var state:Bool?
    var field:String?
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
