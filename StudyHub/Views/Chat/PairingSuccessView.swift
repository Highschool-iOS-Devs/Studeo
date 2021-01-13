//
//  PairingSuccess.swift
//  StudyHub
//
//  Created by Andreas on 12/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct PairingSuccess: View {
    @EnvironmentObject var userData: UserData
    @Binding var paired: Bool
    @Binding var chat: Bool
    @State var group: Groups
    @State var navigationBarHidden: Bool = false
    var body: some View {
        NavigationView {
            ZStack {
                LottieView(name: "34595-confetti-for-ios-and-android")
                VStack {
                    Text("Pairing Successful!")
                        .font(Font.custom("Montserrat-SemiBold", size: 24, relativeTo: .headline))
                Button(action: {
                   chat = true
                }) {
                    Text("Chat")
                        .font(Font.custom("Montserrat-SemiBold", size: 14, relativeTo: .headline))
                } .buttonStyle(BlueStyle())
                .padding()
                
                }
                /*if chat {
                    ChatView(group: $group, navigationBarHidden: self.$navigationBarHidden, show: $chat)
                        .environmentObject(userData)
                }*/
                
                NavigationLink(destination: ChatView(group: $group, navigationBarHidden: self.$navigationBarHidden, show: $chat).environmentObject(userData), isActive: $chat) {
                    EmptyView()
                }
            }
            .onAppear {
                self.navigationBarHidden = true
            }
        }
        
    }
}


