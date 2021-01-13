//
//  Homev2.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//


import SwiftUI
import Firebase
import FirebaseFirestoreSwift
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
    @State var dmChat = false
    @State var group = Groups(id: UUID().uuidString, groupID: "", groupName: "", members: [String](), membersCount: 0, interests: [UserInterestTypes?](), userInVC: [String]())
    @Binding var recommendGroups: [Groups]
    @Binding var user: [User]
    @State var imgs = ["2868759", "66209", "Group", "studying_drawing", "2868759", "66209", "Group", "studying_drawing", "2868759", "66209", "Group", "studying_drawing", "2868759", "66209", "Group", "studying_drawing", "2868759", "66209", "Group", "studying_drawing"]
    @State var sum = 0.0
    @State var animate = true
    @State var animation = true
    @Binding var timerLog: [TimerLog]
    @State var disable = false
    @Binding var devGroup: Groups
    @State var show = false
    @State var users = [String]()
    @State var ready = false
    @State var i = 0
    var body: some View {
        GeometryReader { geo in
        ZStack {
            ZStack(alignment: .top) {
                Color("Background").edgesIgnoringSafeArea(.all)
                    .onAppear() {
                       // userData.hasDev = false
                        recommendGroups.removeAll()
                        if !user.isEmpty {
                        if !user[0].studyHours.isEmpty {
                        
                        sum = user[0].studyHours.reduce(0, +)
                            
                            
                        }
                    }
                        for group in recentPeople {
                            for user in group.members {
                                if user != userData.userID {
                                    users.append(user)
                                    print(user)
                                }
                            }
                        }
                        ready = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                              //  animation.toggle()
                            }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                               // if userData.uses == 2 || userData.uses == 3 || userData.uses == 10 {
                                    if !userData.hasDev {
                        animate = true
                                    }
                       // }
                            }
                        }
                        }
                    }
                if animation {
                VStack {
                    Spacer()
                        .frame(minHeight: 60, idealHeight: 60, maxHeight: 60)
                        .fixedSize()
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        if !userData.hasDev {
                        if animate {
                           
                            DevChatBanner(devGroup: $devGroup, show: $show)
                                .frame(width: geo.size.width, height: geo.size.height/3)
                                .transition(.identity)
                               
                            }
                        }
                        if !disable {
                        if !recentPeople.isEmpty {
                            if !users.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                
                                ForEach(recentPeople.indices, id:\.self){ i in
                                    Button(action: {
                                        
                                        self.i = i
                                        self.group = recentPeople[i]
                                        
                                       
                                        
                                        
                                    }) {
                                        ProfilePic(name: recentPeople[i].groupName, id: users[i])
                                        
                                    }
                                
                                   
                                    //ProfilePic(name: groups.groupName, size: 70)
                                   
                                      
                                    
                                        
                                
                                }
                               
                                Spacer()
                            } .padding(.top, 22)
                            .padding(.horizontal)
                        } .padding(.vertical)
                        Divider()
                            
                            }
                        }
                        }
                        if recommendGroups.isEmpty {
                            
                        } else {
                            if !disable {
                        HStack {
                            Text("Recommended")
                                .font(.custom("Montserrat Bold", size: 18, relativeTo: .headline)).foregroundColor(Color("Primary"))
                            Spacer()
                        }.padding()
                        .padding(.top, 40)
                        
                       
                        ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(Array(recommendGroups.enumerated()), id: \.element) { i, group in
                    
                                        GroupsView(imgName: imgs[i], cta: "Join", name: group.groupName, group: $group)
                                            .onAppear() {
                                             //  self.group = group
                                            }
                                        .padding()
                                   
                                    }
                                    Spacer(minLength: 110)
                                }
                            }
                        }
                        }

                           
                        if user.isEmpty {
                            
                        } else {
                            SelfRankView(hours: sum, id: user[0].id.uuidString)
                                .padding()
                                .padding(.top, 62)
                                .onTapGesture {
                                    viewRouter.updateCurrentView(view: .leaderboard)
                                }
                        }
                        if recentPeople.isEmpty {
                        CTA(imgName: "friends", cta: "Find Study Partners")
                        }
                            CTA(imgName: "mentor", cta: "Find a Mentor")
                               
                             
                         //   CTA(imgName: "study", cta: "Compete")
                           //     .padding()
                        if user.isEmpty {
                            
                        } else {
                        LineView(data: user[0].studyHours, title: "Hours Studied", legend: "", style: Styles.barChartStyleNeonBlueLight)
                                .padding()
                        }
                            Spacer(minLength: 500)
                   
                    
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                        .edgesIgnoringSafeArea(.all)
                        
                    }.disabled(showingTimer ? true : false)
        }
              
                     Header(showTimer: $showingTimer)
                }
            }.blur(radius: showingTimer ? 20 : 0)
            .onChange(of: self.i) { newValue in
                show = true
               dmChat = true
           }
            .fullScreenCover(isPresented: $show, content: {
                if dmChat {
                ChatView(group: $recentPeople[self.i], show: $dmChat)
                        .onDisappear {
                            dmChat = false
                        }
                } else {
                    ChatView(group: $devGroup, show: $dmChat)
                }
                
            })
            if showingTimer {
                VStack {
                    TimerView(showingView: $showingTimer, timerLog: $timerLog)
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            self.viewRouter.showTabBar = false
                        }
                        .onDisappear {
                            self.viewRouter.showTabBar = true
                    }
                }
            }
       
        
        }
       
    
//            if show {
//                ChatView(group: devGroup, show: $show)
//            }

}
       
}
  
    
}

