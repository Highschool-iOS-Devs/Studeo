//
//  IntroPages.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/17/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Combine

struct IntroView: View {
    @State var interests = [String]()
    @State var add: Bool = false
    @State var settings: Bool = false
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var userData: UserData
    
    @State var keyboardHeight: CGFloat = 0.0
    
    @State var currentTab = 0
    var body: some View {
        ZStack {
            
            TabView(selection: $currentTab) {
                VStack {
                    IntroPage(titleText: "Welcome", bodyText: "Welcome to Studeo, a place to study with others and gain motivation. Build the future you've dreamed of, one study session at a time.", image: "studying_drawing", viewRouter: viewRouter)
                    Button(action: {
                        currentTab += 1
                    }) {
                        Text("Next")
                    } .buttonStyle(BlueStyle())
                    .padding()
                } .tag(0)
                VStack {
                    IntroPage(titleText: "Study", bodyText: "Gain motivation by tracking your progress with a study timer and compete with others.", image: "mentor_drawing", viewRouter: viewRouter )
                    Button(action: {
                        currentTab += 1
                    }) {
                        Text("Next")
                    } .buttonStyle(BlueStyle())
                    .padding()
                } .tag(1)
                VStack {
                    IntroPage(titleText: "Motivate", bodyText: "Join a community deticated to motivating each other to study.", image: "timer_drawing", viewRouter: viewRouter)
                    Button(action: {
                        currentTab += 1
                    }) {
                        Text("Next")
                        
                    } .buttonStyle(BlueStyle())
                    .padding()
                } .tag(2)
                VStack {
                    IntroPage(titleText: "Open Sourced", bodyText: "Studeo was created by amazing volunteers...", image: "", isOpenSourceView: true, viewRouter: viewRouter)
                    Button(action: {
                        currentTab += 1
                    }) {
                        Text("Next")
                        
                    } .buttonStyle(BlueStyle())
                    .padding()
                } .tag(3)
                VStack {
                    RegistrationView(viewRouter: viewRouter, userData: userData)
                        .padding(.bottom, keyboardHeight)
                    
                } .tag(4)
            }.tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            .transition(.opacity)
            .animation(.easeInOut(duration: 1.5))
            .ignoresSafeArea(.all, edges: .bottom)
            
            .onReceive(Publishers.keyboardHeight) { value in
                withAnimation(.easeInOut(duration: 0.7)) { self.keyboardHeight = value }
                
            }
        }
    }
    
    
    
}
