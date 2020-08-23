//
//  LeaderboardTabBar.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Foundation

class LeaderBoardTabRouter:ObservableObject{
    enum tabViews{
           case today
           case week
           case allTime
       }
    @Published var currentDateTab = tabViews.allTime
}

   
