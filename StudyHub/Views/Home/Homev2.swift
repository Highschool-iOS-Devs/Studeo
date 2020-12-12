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
    @State var chat = false
    @State var group = Groups(id: UUID().uuidString, groupID: "", groupName: "", members: [String](), interests: [UserInterestTypes?]())
    @Binding var user: [User]
    var body: some View {
        ZStack(alignment: .top){
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                    .frame(minHeight: 60, idealHeight: 60, maxHeight: 60)
                    .fixedSize()
                
                    ScrollView(.vertical, showsIndicators: false) {
                    ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(recentPeople, id:\.self){groups in
                            ProfilePic(name: groups.groupName, size: 70)
                                .onTapGesture() {
                                    group = groups
                                    chat.toggle()
                                }
                        }

                    } .padding(.top)
                    }
                    Divider()
                    HStack {
                        Text("Groups")
                            .font(Font.custom("Montserrat-SemiBold", size: 20.0))
                        Spacer()
                    }.padding()
                        
                    ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Spacer(minLength: 20)
                                GroupsView(imgName: "2868759", cta: "Join", name: "Debate")
                                GroupsView(imgName: "3566801", cta: "Join", name: "Spanish")
                                GroupsView(imgName: "Group", cta: "Join", name: "History")
                                Spacer(minLength: 110)
                            }
                        }
               
                       
                        
                        SelfRankView(hours: user[0].studyHours)
                            .padding()
                        //CTA(imgName: "Group", cta: "Add Group")
                           
                         
                        CTA(imgName: "study", cta: "Compete")
                            .padding()
                        Spacer(minLength: 140)
               
                
                    .transition(.move(edge: .bottom))
                    .zIndex(1)
                    .edgesIgnoringSafeArea(.all)
                    
                    }
    }.blur(radius: showingTimer ? 20 : 0)
                if showingTimer {
                    TimerView(showingView: $showingTimer)
                        .padding(.bottom, 110)
                        .onAppear {
                            self.viewRouter.showTabBar = false
                        }
                        .onDisappear {
                            self.viewRouter.showTabBar = true
                        }
                }
            
                 Header(showTimer: $showingTimer)
                     .frame(height: 120)
                     .background(BlurView(style: .systemMaterial))
                     //.padding(.top, 40)
                     .edgesIgnoringSafeArea(.all)
            
            if chat {
                Color(.systemBackground)
                ChatView(userData: _userData, group: group, chatRoomID: $group.groupID, chat: $chat)
                    .environmentObject(userData)
                    .onAppear() {
                        viewRouter.showTabBar = false
                    }
                    .onDisappear() {
                        viewRouter.showTabBar = true
                    }
            }
        }
    }


}



