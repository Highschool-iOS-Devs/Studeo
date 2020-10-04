//
//  TabBar.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct tabItemView: View {
    var SFImage:String
    var text:String
    var tabType: ViewRouter.Views
    @EnvironmentObject var viewRouter:ViewRouter

    var body: some View {
        VStack {
            Image(systemName: SFImage)
                .font(.system(size: 20))
                .padding(.bottom, 5)
                .foregroundColor(viewRouter.currentView == tabType ? Color("barHighlight") : Color.black.opacity(0.25))
            
            Text(text)
                .font(.custom("Montserrat-Bold", size: 10))
                .foregroundColor(viewRouter.currentView == tabType ? Color("barHighlight") : Color.black.opacity(0.25))
            
        }
        
        .padding(.top, 15)
        
    }
}


struct tabBarView: View {
    @EnvironmentObject var viewRouter:ViewRouter
    
    var body: some View {
        VStack {
            
            Spacer()
            HStack {
                
                HStack {
                    
                    tabItemView(SFImage: "message.fill", text: "Chat", tabType: .chats)
                        
                        .onTapGesture {
                            self.viewRouter.updateCurrentView(view: .chatList)
                        }
                    Spacer()
                    tabItemView(SFImage: "book.fill", text: "Books", tabType: .books)
                        // .padding(.trailing, 60)
                        .onTapGesture {
                            self.viewRouter.updateCurrentView(view: .books)
                        }
                    Spacer()
                } .padding()
                Spacer()
                HStack {
                    Spacer()
                    tabItemView(SFImage: "person.2.fill", text: "Groups", tabType: .groups)
                        //.padding(.leading, 60)
                        .onTapGesture {
                            self.viewRouter.updateCurrentView(view: .groups)
                        }
                    Spacer()
                    tabItemView(SFImage: "gear", text: "Settings", tabType: .settings)
                        
                        .onTapGesture {
                            self.viewRouter.updateCurrentView(view: .settings)
                        }
                    
                } .padding()
                
            }
            .padding(.bottom)

          .frame(width: screenSize.width, height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(Color.white.shadow(radius: 0.5))
            .overlay(
                tabBigButton()
                    .onTapGesture {
                        self.viewRouter.updateCurrentView(view: .home)
                    }
            )
            
            
            
        }.edgesIgnoringSafeArea(.all)
        
    }
}
struct tabBarView_previews: PreviewProvider {
    static var previews: some View {
        tabBarView()
    }
}
struct tabBigButton: View {
    @EnvironmentObject var viewRouter:ViewRouter

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
        .offset(x: 0, y: -50)
        .animation(Animation
                    .easeInOut
                  )
    }
}
