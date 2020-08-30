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
        //Below are temp views for testing Firebase
        case login
        case registration
        case chatList
        
       }
    @Published var currentView = Views.login
    public static let shared = ViewRouter()
    func updateCurrentView(view:Views){
        print("Changing current view to \(view)")
        self.currentView = view
    }
}

   
