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
    @ObservedObject var tabRouter = TabRouter()
    @Environment(\.presentationMode) var presentationMode
    @State private var showSheet = false
    var body: some View {
        
        ZStack {
            Color(.white)
                .onAppear() {
                    if Auth.auth().currentUser?.uid == nil {
                        self.showSheet = true
                    }
            }
            GeometryReader { geometry in
                if self.tabRouter.currentView == .chats {
                    ChatList()
                }
                else if self.tabRouter.currentView == .books {
                    Text("Books View")
                }
                else if self.tabRouter.currentView == .groups {
                    Text("Groups View")
                }
                else if self.tabRouter.currentView == .settings {
                    SettingView()
                        .transition(.move(edge: .bottom))
                        .animation(.timingCurve(0.06,0.98,0.69,1))
                }
                else if self.tabRouter.currentView == .home {
                    Home()
                        .transition(.move(edge: .bottom))
                        .animation(.timingCurve(0.06,0.98,0.69,1))
                }
                
                
                tabBarView(tabRouter: self.tabRouter, currentView: self.$tabRouter.currentView)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y: geometry.size.height/50)
            }.padding(.vertical, 12)
                
                
                .sheet(isPresented: $showSheet) {
                    RegistrationView()
                    .environmentObject(UserData.shared)
                    
                    
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
