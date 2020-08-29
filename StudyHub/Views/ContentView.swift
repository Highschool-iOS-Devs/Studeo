//
//  ContentView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: UserData
     @ObservedObject var tabRouter = TabRouter()
    var body: some View {
        
        ZStack {
                  if tabRouter.currentView == .chats{
                      ChatList()
                  }
                  else if tabRouter.currentView == .books{
                      Text("Books View")
                  }
                  else if tabRouter.currentView == .groups{
                      Text("Groups View")
                  }
                  else if tabRouter.currentView == .settings{
                      SettingView()
                          .transition(.move(edge: .bottom))
                          .animation(.timingCurve(0.06,0.98,0.69,1))
                  }
                  else if tabRouter.currentView == .home{
                      Home()
                      .transition(.move(edge: .bottom))
                      .animation(.timingCurve(0.06,0.98,0.69,1))
                  }
                  tabBarView(tabRouter: tabRouter, currentView: $tabRouter.currentView)
           
            }.padding(.vertical, 12)
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
