//
//  ContentView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @State private var hasCheckedAuth = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showSheet = false

    var body: some View {
        ZStack { 
            Color.white
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    self.checkAuth()
            }
            if self.hasCheckedAuth {
                
            if viewRouter.currentView == .registration{
                RegistrationView()
                    .environmentObject(viewRouter)
            }
            else if viewRouter.currentView == .login {
                LoginView()
                    .environmentObject(viewRouter)
            }
            else if viewRouter.currentView == .chatList {
                    RecentsView()
           
            }
            else if viewRouter.currentView == .groups {
                    AddChat()
                
            }
            else if viewRouter.currentView == .leaderboard {
                    LeaderboardView()
            }
            else if viewRouter.currentView == .home {
                    Home()
            }
            else if viewRouter.currentView == .settings{
                SettingView()
                .environmentObject(viewRouter)
                }
            else if viewRouter.currentView == .chats{
                ChatView()
                .environmentObject(userData)
                }
        }
            if viewRouter.currentView != .registration && viewRouter.currentView != .login{
                VStack{
                    Spacer()
                    tabBarView()
                    }
            }
           
        }
        

}
    func checkAuth(){
        
        if Auth.auth().currentUser != nil {
                
           self.viewRouter.currentView = .home
            self.hasCheckedAuth = true
                
         } else {
            self.viewRouter.currentView = .registration
            self.hasCheckedAuth = true
        }
    }
    }


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
