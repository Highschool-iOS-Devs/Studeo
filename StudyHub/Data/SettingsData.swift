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

}
struct SettingSubData:Codable{
    var name:String
    var state:Bool?
    var field:String?
}
