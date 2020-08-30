//
//  TabBar.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var tabRouter = ViewRouter()
    var body: some View {
        
        ZStack {
            if tabRouter.currentView == .chats{
                Text("Chat View")
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
        }
        
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

struct tabItemView: View {
    var SFImage:String
    var text:String
    var tabType: ViewRouter.Views
    @Binding var currentView: ViewRouter.Views
    
    var body: some View {
        VStack {
            Image(systemName: SFImage)
                .font(.system(size: 20))
                .padding(.bottom, 5)
                .foregroundColor(self.currentView == tabType ? Color("barHighlight") : Color.black.opacity(0.25))
            
            Text(text)
                .font(.custom("Montserrat-Bold", size: 10))
                .foregroundColor(self.currentView == tabType ? Color("barHighlight") : Color.black.opacity(0.25))
            
        }
        .frame(width:60)
        .padding(.top, 15)
        
    }
}
 

struct tabBarView: View {
    var tabRouter:ViewRouter
    @Binding var currentView: ViewRouter.Views
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                tabItemView(SFImage: "message.fill", text: "Chat", tabType: .chats, currentView: self.$currentView)
                .onTapGesture {
                    self.currentView = .chats
            }
          
                tabItemView(SFImage: "book.fill", text: "Books", tabType: .books, currentView: self.$currentView)
                    .padding(.trailing, 30)
                .onTapGesture {
                        self.currentView = .books
                }
                tabItemView(SFImage: "person.2.fill", text: "Groups", tabType: .groups, currentView: self.$currentView)
                    .padding(.leading, 30)
                .onTapGesture {
                        self.currentView = .groups
                }
                tabItemView(SFImage: "gear", text: "Settings", tabType: .settings, currentView: self.$currentView)
                .onTapGesture {
                        self.currentView = .settings
                }
                
            }
            .frame(width: screenSize.width, height: screenSize.height/10)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(Color.white.shadow(radius: 2))
            .overlay(
                
                tabBigButton(currentView: $currentView)
                    .onTapGesture {
                        self.currentView = .home
                }
            )
            
            
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct tabBigButton: View {
    @Binding var currentView: ViewRouter.Views
    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.gradientLight, Color.gradientDark]), startPoint: .topTrailing, endPoint: .bottomLeading))
                .frame(width: 70, height: 70)
               
            Image(systemName: "house.fill")
                .frame(alignment: .center)
                .foregroundColor(Color.white)
                .font(.system(size: 28))
        }
        .offset(x: 0, y: -30)
        .animation(Animation
                    .easeInOut
                  )
    }
}
