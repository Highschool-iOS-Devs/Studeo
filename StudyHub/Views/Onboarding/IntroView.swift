//
//  IntroPages.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/17/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI


struct IntroView: View {
    @State var interests = [String]()
    @State var add: Bool = false
    @State var settings: Bool = false
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var userData: UserData

        
    
    var body: some View {
        ZStack {
           
            TabView {
                IntroPage(titleText: "Welcome", bodyText: "Welcome to Studeo, a place to study with others and gain motivation. Build the future you've dreamed of, one study session at a time.", image: "studying_drawing", viewRouter: viewRouter)
                    
                
                IntroPage(titleText: "Study", bodyText: "Gain motivation by tracking your progress with a study timer and compete with others.", image: "mentor_drawing", viewRouter: viewRouter )
                IntroPage(titleText: "Motivate", bodyText: "Join a community deticated to motivating each other to study.", image: "timer_drawing", viewRouter: viewRouter)
                IntroPage(titleText: "Open Sourced", bodyText: "Studeo was created by amazing volunteers...", image: "", isOpenSourceView: true, viewRouter: viewRouter)
                RegistrationView(viewRouter: viewRouter, userData: userData)
                    
                    .ignoresSafeArea()
                
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            .transition(.opacity)
            .animation(.easeInOut(duration: 1.5))
            .ignoresSafeArea(.all, edges: .bottom)

       
        }
    }
}



