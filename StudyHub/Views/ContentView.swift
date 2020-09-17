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
                   //  FirebaseManager().signOut()
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
                .environmentObject(userData)
           
            }
            else if viewRouter.currentView == .groups {
                    AddChat()
                .environmentObject(userData)
                
            }
            else if viewRouter.currentView == .leaderboard {
                    LeaderboardView()
                .environmentObject(userData)
            }
            else if viewRouter.currentView == .home {
                    Home()
                .environmentObject(userData)
            }
            else if viewRouter.currentView == .settings{
                SettingView()
                .environmentObject(viewRouter)
                environmentObject(userData)
                }
        }
            if viewRouter.showTabBar == true || viewRouter.currentView != .registration || viewRouter.currentView != .login {
                VStack{
                    Spacer()
                    tabBarView()
                }.transition(AnyTransition.move(edge: .bottom))
                    .animation(Animation.easeInOut)
            }

        }
        

}
    func checkAuth(){
        DispatchQueue.global(qos: .background).async {
            Auth.auth().addStateDidChangeListener { (auth, user) in
                print(user)
                if user != nil{
                    self.viewRouter.currentView = .home
                    self.hasCheckedAuth = true
                }
                else {
                    self.viewRouter.currentView = .registration
                    self.hasCheckedAuth = true
                }
               
            }
        }
         
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
