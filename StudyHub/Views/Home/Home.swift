//
//  Home.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var userData: UserData
     @EnvironmentObject var viewRouter:ViewRouter
    @State private var search: String = ""
    @State private var showingTimer = false
    @State var myGroups = [Groups]()
    
    var body: some View {
        ZStack {
            VStack {
                ScrollView(showsIndicators: false) {
                    Header(showTimer: $showingTimer)
                    //SearchBar()
                    
                    Spacer()
                    HStack {
                        
                        Text("Start here!")
                            .frame(minWidth: 100, alignment: .leading)
                            .font(.custom("Montserrat-Semibold", size: 18))
                            .foregroundColor(Color(.black))
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    } .padding(.horizontal, 12)
                    
                    CTA(imgName: "friends", cta: "Add Friends")
                        
                   // CTA(imgName: "Group", cta: "Add Group")
                       
                   //  CTA(imgName: "study", cta: "Compete")
                        
                    Spacer(minLength: 140)
                    
                }
               
            }
            .blur(radius: showingTimer ? 20 : 0)
        
        if showingTimer {
            TimerView(showingView: $showingTimer)
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

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
