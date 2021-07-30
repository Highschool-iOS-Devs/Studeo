//
//  RecentChatGroupSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct RecentChatGroupSubview: View {
    @State var group:Groups
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter: ViewRouter
    @State var show = false
    @Binding var hideNavBar: Bool
    
    var body: some View {
        NavigationLink(destination: ChatView(userData: userData, viewRouter: viewRouter, group: $group, show: $show, hideNavBar: $hideNavBar)
                        
                        .onAppear() {
                            viewRouter.showTabBar = false
                        }
                        .onDisappear() {
                            viewRouter.showTabBar = true
                        }
        ){
            ZStack {
                Color("GroupCard")
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color("CardShadow"), radius:3, x:0, y:0)
                    .padding()
                    .frame(minHeight: 150)
                VStack{
                    Text(group.groupName)
                        .font(Font.custom("Montserrat-Bold", size: 20, relativeTo: .headline))
                        
                        .minimumScaleFactor(0.1)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color.white.opacity(0.96))
                        .multilineTextAlignment(.center)
                        .padding(.bottom,2)
                    //5 members
                    
                    Text("\(group.members.count) members").font(Font.custom("Montserrat-SemiBold", size: 12, relativeTo: .headline)).foregroundColor(Color.white.opacity(0.96)).multilineTextAlignment(.center)
                        //Available in iOS 14 only
                        .textCase(.uppercase)
                        //SAT
                        .multilineTextAlignment(.leading)
                }
                .padding()
                
                
            }
        }
        
        
    }
}

//struct RecentChatGroupSubview_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentChatGroupSubview(group: Groups)
//    }
//}
struct RecentChatGroupSubview2: View {
    @State var group:Groups
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter: ViewRouter
    @State var show = false
    var body: some View {
        
        ZStack {
            Color("GroupCard")
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(color: Color("CardShadow"), radius:3, x:0, y:0)
                .padding()
                .frame(minHeight: 150)
            VStack {
                Text(group.groupName)
                    .font(Font.custom("Montserrat-Bold", size: 20, relativeTo: .headline))
                    
                    .minimumScaleFactor(0.1)
                    
                    .foregroundColor(Color.white.opacity(0.96))
                    .multilineTextAlignment(.center)
                    .padding(.bottom,2)
                //5 members
                
                Text("\(group.members.count) members").font(Font.custom("Montserrat-SemiBold", size: 12, relativeTo: .headline)).foregroundColor(Color.white.opacity(0.96)).multilineTextAlignment(.center)
                    //Available in iOS 14 only
                    .textCase(.uppercase)
                //SAT
                
            }
            .padding()
            
            
        }
        
        
        
    }
}

//struct RecentChatGroupSubview_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentChatGroupSubview(group: Groups)
//    }
//}
