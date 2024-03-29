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
        case home
        case settings
        case introView
        //Below are temp views for testing Firebase
        case login
        case registration
        case chatList
        case leaderboard
        case profile
        case custom
        case mentor
        case quizList
        case devChat
        case mentorCustom
    }
    @Published var currentView = Views.registration
    @Published var showChatView = false {
        willSet {
            showTabBar.toggle()
        }
    }
    @Published var showTabBar = false
    public static let shared = ViewRouter()
    func updateCurrentView(view:Views) {
        self.currentView = view
    }
}





class QuizRouter: ObservableObject{
    enum Views {
        case leaderboard
        case question
    }
    @Published var currentView = Views.question
    @Published var nextView = Views.leaderboard
    public static let shared = QuizRouter()
    func updateCurrentView(view: Views) {
        self.currentView = view
    }
}

