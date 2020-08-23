//
//  tabRouter.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Foundation

class TabRouter:ObservableObject{
    enum tabViews{
           case chats
           case home
           case books
           case groups
           case settings
       }
    @Published var currentView = tabViews.home
}

   
