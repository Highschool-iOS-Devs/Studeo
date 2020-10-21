//
//  Homev2.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Homev2: View {
    var columns = [
        GridItem(.fixed(250)),
        GridItem(.flexible()),
       
    ]
    var columns2 = [
        GridItem(.fixed(200)),
        GridItem(.flexible()),
       
    ]
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @State var columns3 = [GridItem]()
    @State var columns4 = [GridItem]()
    @State  var transition: Bool = false
    let screenSize = UIScreen.main.bounds
    @State private var showingTimer = false
    @State var size = CGSize(width: 0, height: -200)
    @State var size2 = CGSize(width: 0, height: 20000)
    @State var scrollOffset = 0
    @State var currentOffset = 0
    @Binding var recentPeople: [Groups]
    var body: some View {
        ZStack {
            Color(.systemBackground)
            VStack {
               
            Header(showTimer: $showingTimer)
         
                .onAppear() {
                    withAnimation(.easeInOut) {
                    transition.toggle()
                }
                }
                    
              
                VStack {
                    ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                       
                        if recentPeople.count > 0 {
                            ProfilePic(name: recentPeople[0].groupName)
                                
                                
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.1)
                                  
                            )
                            .transition(.move(edge: .top))
                        }
                            
                        if recentPeople.count > 1 {
                            ProfilePic(name: recentPeople[1].groupName)
                                
                                
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.2)
                                   
                                  
                            )
                            .transition(.move(edge: .top))
                      } else {
                        Spacer()
                    }
                    
                   
                        if recentPeople.count > 2 {
                            ProfilePic(name: recentPeople[2].groupName)
                             
                              
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.3)
                                  
                            )
                            .transition(.move(edge: .top))
                        }
                        if recentPeople.count > 3 {
                            ProfilePic(name: recentPeople[3].groupName)
                                
                               
                            .animation(
                                Animation.easeInOut(duration: 2)
                                    .delay(0.4)
                                   
                                  
                            )
                            .transition(.move(edge: .top))
                        } else {
                            Spacer()
                               
                        }
                    }
                    }
                    .padding(.bottom, 62)
                    HStack {
                        Text("Groups")
                            .font(Font.custom("Montserrat-SemiBold", size: 20.0))
                        Spacer()
                    } .padding()
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer(minLength: 20)
                                GroupsView(imgName: "2868759", cta: "Chat", name: "Name")
                                GroupsView(imgName: "3566801", cta: "Chat", name: "Name")
                                GroupsView(imgName: "Group", cta: "Chat", name: "Name")
                                Spacer(minLength: 110)
                            }
                        }
                        Spacer(minLength: 62)
                        
                        SelfRankView(hours: 3.0)
                        
                        CTA(imgName: "Group", cta: "Add Group")
                           
                         
                            
                        Spacer(minLength: 140)
               
                
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    .edgesIgnoringSafeArea(.all)
                    
                    }
    }.blur(radius: showingTimer ? 20 : 0)
                if showingTimer {
                    TimerView(showingView: $showingTimer)
                        .padding(.bottom, 110)
                }
        }
    }


}
}
