//
//  TabBar.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @ObservedObject var tabRouter = TabRouter()
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
            }
            else if tabRouter.currentView == .home{
                Home()
            }
            tabBarView(tabRouter: tabRouter)
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
    var body: some View {
        VStack {
            Image(systemName: SFImage)
                .font(.system(size: 20))
                .padding(.bottom, 5)
            
            Text(text)
                .font(.custom("Montserrat-Bold", size: 10))
            
        }
        .frame(width:60)
        .padding(.top, 15)
        
    }
}
 

struct tabBarView: View {
    var tabRouter:TabRouter
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                tabItemView(SFImage: "message.fill", text: "Chat")
                    .foregroundColor(tabRouter.currentView == .chats ? Color("barHighlight") : Color.black.opacity(0.25))
                .onTapGesture {
                    self.tabRouter.currentView = .chats
            }
          
                tabItemView(SFImage: "book.fill", text: "Books")
                    .padding(.trailing, 30)
                .foregroundColor(tabRouter.currentView == .books ? Color("barHighlight") : Color.black.opacity(0.25))
                .onTapGesture {
                        self.tabRouter.currentView = .books
                }
                tabItemView(SFImage: "person.2.fill", text: "Groups")
                    .padding(.leading, 30)
                .foregroundColor(tabRouter.currentView == .groups ? Color("barHighlight") : Color.black.opacity(0.25))
                .onTapGesture {
                        self.tabRouter.currentView = .groups
                }
                tabItemView(SFImage: "gear", text: "Settings")
                    .foregroundColor(tabRouter.currentView == .settings ? Color("barHighlight") : Color.black.opacity(0.25))
                .onTapGesture {
                        self.tabRouter.currentView = .settings
                }
                
            }
            .frame(width: screenSize.width, height: screenSize.height/10)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(Color.white.shadow(radius: 2))
            .overlay(
                
                tabBigButton()
                    .foregroundColor(tabRouter.currentView == .home ? Color("secondary") : Color("secondary").opacity(0.8))
                    .onTapGesture {
                    self.tabRouter.currentView = .home
                }
            )
            
            
            
        }.edgesIgnoringSafeArea(.all)
    }
}

struct tabBigButton: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Color("Secondary"))
                .frame(width: 70, height: 70)
            Image(systemName: "house.fill")
                .frame(alignment: .center)
                .foregroundColor(.white)
                .font(.system(size: 28))
        }
        .offset(x: 0, y: -30)
    }
}
