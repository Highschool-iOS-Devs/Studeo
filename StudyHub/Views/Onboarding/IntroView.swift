//
//  IntroPages.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/17/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import PageView
public enum CurrentPage:CaseIterable {
    case page1, page2, page3,page4
    mutating func increase() {
        let a = Self.allCases
        self = a[(a.firstIndex(of: self)! + 1) % a.count]
        }
    func getCases() -> [CurrentPage]{
        return Self.allCases
    }
}

struct IntroView: View {
    @State var interests = [String]()
    @State var add: Bool = false
    @State var settings: Bool = false
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userData: UserData
    @State var index = 0 {
        willSet{
            print("will set \(index)")
        }
        didSet{
            print("did set \(index)")
        }
    }
    @State var currentView: CurrentPage = CurrentPage.page1 {
        willSet{
            if currentView == .page3 {
                currentView = .page4
            }
        }
    }
        
    
    var body: some View { 
        ZStack {
           
            HPageView(selectedPage: $index) {
                IntroPage(titleText: "Welcome", bodyText: "Welcome to Study Hub, a place where you can get help and motivation. Build the future you dreamed of, one study session at a time.", image: "studying_drawing")
                IntroPage(titleText: "Study", bodyText: "Gain motivation by tracking your progress with a study timer and compete with others on a leaderboard.", image: "mentor_drawing" )
                IntroPage(titleText: "Motivate", bodyText: "Join a community deticated to motivating each other to study.", image: "timer_drawing")
                RegistrationView()
                    .environmentObject(ViewRouter.shared)
                    .environmentObject(UserData.shared)
                
            } 
          
        
        

       
        }
    }
}

struct IntroPages_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}

struct PointerCircles: View {
    @Binding var currentView:CurrentPage
    
    var body: some View {
        ForEach(currentView.getCases(), id: \.self){cases in
            Circle()
                .foregroundColor(currentView == cases ? Color(#colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                .frame(width: 7, height: 7)
        }
       
    }
}


