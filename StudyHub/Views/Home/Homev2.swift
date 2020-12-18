//
//  Homev2.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//


import SwiftUI
import SwiftUICharts
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
    @Binding var recommendGroups: [Groups]
    @Binding var user: [User]
    var body: some View {

        ZStack {
            ZStack(alignment: .top){
                Color("Background").edgesIgnoringSafeArea(.all)
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
                            Text("Recommended")
                                .font(.custom("Montserrat Bold", size: 24)).foregroundColor(Color("Primary"))
                            Spacer()
                        }.padding()
                            
                        ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(recommendGroups, id:\.self){ group in
                    
                                        GroupsView(imgName: "2868759", cta: "Join", name: group.groupName)
                                        .padding()
                                   
                                    }
                                    Spacer(minLength: 110)
                                }
                            }
                   

                           
                            
                            SelfRankView(hours: user[0].studyHours)
                                .padding()
                            //CTA(imgName: "Group", cta: "Add Group")
                               
                             
                            CTA(imgName: "study", cta: "Compete")
                                .padding()
                            
                            //LineView(data: [8,23,54,32,12,37,7,23,43], title: "Hours Studied", legend: "", style: Styles.barChartStyleNeonBlueLight)
                                .padding()
                            Spacer(minLength: 500)
                   
                    
                        .transition(.move(edge: .bottom))
                        .zIndex(1)
                        .edgesIgnoringSafeArea(.all)
                        
                    }.disabled(showingTimer ? true : false)
        }
              
                     Header(showTimer: $showingTimer)
                  
            }.blur(radius: showingTimer ? 20 : 0)
            if showingTimer {
                VStack {
                    TimerView(showingView: $showingTimer)
                        .padding(.top, 110)
                        .onAppear {
                            self.viewRouter.showTabBar = false
                        }
                        .onDisappear {
                            self.viewRouter.showTabBar = true
                    }
                }
            if chat {
                Color(.systemBackground)
                ChatView(group: group, chat: $chat)
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

}

