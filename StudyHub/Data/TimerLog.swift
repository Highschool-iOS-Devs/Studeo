//
//  TimerLog.swift
//  StudyHub
//
//  Created by Andreas on 12/26/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TimerLog: Identifiable, Codable {
    var id = UUID()
    var userID: String
    var category: String
    var time: Double
    var date: Double

}
