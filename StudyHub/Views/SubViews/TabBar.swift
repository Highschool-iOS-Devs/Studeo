//
//  TabBar.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct tabItemView: View {
    var SFImage: String
    var text: String
    var tabType: ViewRouter.Views
    @ObservedObject var viewRouter: ViewRouter
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack {
            Image(systemName: SFImage)
                .font(.system(size: 20))
                .padding(.bottom, 5)
                .foregroundColor(viewRouter.currentView == tabType ? Color("barHighlight") : Color("Text").opacity(0.25))
            
            Text(text)
                .font(.custom("Montserrat-Bold", size: 10))
                .foregroundColor(viewRouter.currentView == tabType ? Color("barHighlight") : Color("Text").opacity(0.25))
            
        }
        
        
        
    }
}


struct tabBarView: View {
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            
            Spacer()
            
            
            HStack {
                
                tabItemView(SFImage: "message.fill", text: "Chat", tabType: .chatList, viewRouter: viewRouter)
                    .onTapGesture {
                        self.viewRouter.updateCurrentView(view: .chatList)
                    }
                
                Spacer()
                
                
                tabItemView(SFImage: "gear", text: "Settings", tabType: .settings, viewRouter: viewRouter)
                    .onTapGesture {
                        self.viewRouter.updateCurrentView(view: .settings)
                    }
                
                
            }
            .padding(62)
            .frame(height: 90)
            .frame(width: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            //.background(BlurView(style: .systemMaterial).shadow(radius: 0.5))
            .background(Color("Background").shadow(color: Color("shadow"), radius: 1.5))
            .overlay(
                tabBigButton(viewRouter: viewRouter)
                    .onTapGesture {
                        self.viewRouter.updateCurrentView(view: .home)
                    }
            )
            
            
            
        }
        .edgesIgnoringSafeArea(.all)
        
    }
}

struct tabBigButton: View {
    @ObservedObject var viewRouter: ViewRouter
    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color.gradientLight, Color.gradientDark]), startPoint: .topTrailing, endPoint: .bottomLeading))
                .frame(width: 80, height: 80)
            
            Image(systemName: "house.fill")
                .frame(alignment: .center)
                .foregroundColor(Color.white)
                .font(.system(size: 28))
        }
        .offset(x: 0, y: viewRouter.showTabBar ? -50 : 0)
        .animation(Animation.easeInOut)
    }
}
