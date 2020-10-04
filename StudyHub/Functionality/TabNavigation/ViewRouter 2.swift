//
//  tabRouter.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Foundation

class ViewRouter:ObservableObject{
    enum Views{
           case chats
           case home
           case books
           case groups
           case settings
            case introView
        case login
        case registration
        case chatList
        case leaderboard
        case profile
        
       }
    @Published var currentView = Views.registration
    @Published var showChatView = false {
        willSet{
            showTabBar.toggle()
        }
    }
    @Published var showTabBar = true
    public static let shared = ViewRouter()
    func updateCurrentView(view:Views){
        self.currentView = view
    }
}



   
