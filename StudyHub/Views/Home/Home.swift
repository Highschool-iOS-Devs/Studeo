//
//  Home.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @ObservedObject var userData: UserData
     @ObservedObject var viewRouter:ViewRouter
    @State private var search: String = ""
    @State private var showingTimer = false
    @State var myGroups = [Groups]()
    @State var animate = false
    @Binding var timerLog: [TimerLog]
    var body: some View {
        ZStack {
            VStack {
               EmptyView()
                    .ignoresSafeArea()
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 2.0)) {
                               
                             //   if userData.uses == 1 || userData.uses == 2 || userData.uses == 10 {
                                    if !userData.hasDev {
                        animate = true
                               //     }
                        }
                            }
                        }
                    }
               
                ScrollView(showsIndicators: false) {
                    if animate {
                  //  DevChatBanner()
                       
                       
                      //  .transition(.move(edge: .top))
                       
                    }
                       
                    //SearchBar()
                    
                    Spacer()
                    HStack {
                        
                        Text("Start here!")
                            .frame(minWidth: 100, alignment: .leading)
                            .font(.custom("Montserrat-Semibold", size: 18))
                            .foregroundColor(Color("Primary"))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    } .padding(.horizontal, 12)
                    
                   
                        
                    CTA(imgName: "mentor", cta: "Find a Mentor", tabRouter: viewRouter, userData: userData)
                    
                    CTA(imgName: "friends", cta: "Add Friends", tabRouter: viewRouter, userData: userData)
                    
                   // CTA(imgName: "Group", cta: "Add Group")
                       
                    // CTA(imgName: "study", cta: "Compete")
                        
                    Spacer(minLength: 200)
                    
                }
               
            }
            .blur(radius: showingTimer ? 20 : 0)
        
        if showingTimer {
            TimerView(showingView: $showingTimer, timerLog: $timerLog)
                .onAppear {
                    self.viewRouter.showTabBar = false
                }
                .onDisappear {
                    self.viewRouter.showTabBar = true
                }
        }
        }
        .onAppear {
            self.viewRouter.showTabBar = true
        }
    }
}


