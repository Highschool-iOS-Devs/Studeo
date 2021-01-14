//
//  TimerStatsView.swift
//  StudyHub
//
//  Created by Andreas on 12/28/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
//import SwiftUICharts

struct TimerStatsView: View {
    @Binding var timerLog: [TimerLog]
    @State var math = [Double]()
    @State var science = [Double]()
    @State var social = [Double]()
    @State var cs = [Double]()
    @State var langauge = [Double]()
    @State var english = [Double]()
    @State var other = [Double]()
    @State var calculate = false
    @Binding var stats: Bool
    var body: some View {
       
        ZStack {
        Color("Background")
            .onAppear() {
                for log in timerLog {
                    if log.category == "Math" {
                        math.append(Double(log.time))
                       
                    }
                    if log.category == "Science" {
                        science.append(Double(log.time))
                       
                    }
                    if log.category == "Social Studies" {
                        social.append(Double(log.time))
                       
                    }
                    if log.category == "Computer Science" {
                        cs.append(Double(log.time))
                       
                    }
                    if log.category == "Foreign Language" {
                        langauge.append(Double(log.time))
                       
                    }
                    if log.category == "English" {
                        english.append(Double(log.time))
                       
                    }
                    if log.category == "Other" {
                        other.append(Double(log.time))
                       
                    }
                    calculate = true
                }
            }
            if calculate {
            ScrollView {
           
                HStack {
                    Button(action: {
                        stats = false
                    }) {
                        Image(systemName: "xmark")
                    }
                    Spacer()
                } .padding()
                
                VStack {
                
                if !langauge.isEmpty {
                    TimerCardView(category: "Foreign Language", points: langauge.reduce(0, +))
                    .padding()
                LineChartView(data: langauge, title: "Foreign Language", legend: "Seconds", dropShadow: false)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    .shadow(color: Color("Primary").opacity(0.1), radius: 15)
                    .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
                }
                if !math.isEmpty {
                    TimerCardView(category: "Math", points: math.reduce(0, +))
                    .padding()
                LineChartView(data: math, title: "Math", legend: "Seconds", dropShadow: false)
                   
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    .shadow(color: Color("Primary").opacity(0.1), radius: 15)
                    .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
                }
                if !social.isEmpty {
                    TimerCardView(category: "Social Studies", points: social.reduce(0, +))
                    
                LineChartView(data: social, title: "Social Studies", legend: "Seconds", dropShadow: false)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    .shadow(color: Color("Primary").opacity(0.1), radius: 15)
                    .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
                }
                if !science.isEmpty {
                    TimerCardView(category: "Science", points: science.reduce(0, +))
                    .padding()
                LineChartView(data: science, title: "Science", legend: "Seconds", dropShadow: false)
                    
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    .shadow(color: Color("Primary").opacity(0.1), radius: 15)
                    .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
                }
               
                if !english.isEmpty {
                    TimerCardView(category: "English", points: english.reduce(0, +))
                   
                LineChartView(data: english, title: "English", legend: "Seconds", dropShadow: false)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    .shadow(color: Color("Primary").opacity(0.1), radius: 15)
                    .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
                }
                if !other.isEmpty {
                    TimerCardView(category: "Other", points: other.reduce(0, +))
                    
                LineChartView(data: other, title: "Other", legend: "Seconds",dropShadow: false)
                    .padding()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    
                    .shadow(color: Color("Primary").opacity(0.1), radius: 15)
                    .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
            }
                } .padding()
          //  }
            }
            
            } else {
                VStack {
                HStack {
                    Button(action: {
                        stats = false
                    }) {
                        Image(systemName: "xmark")
                    }
                    Spacer()
                } .padding()
                Text("Study using the study timer to unlock stats. 🙌").font(.custom("Montserrat Bold", size: 24)).foregroundColor(Color(#colorLiteral(red: 0.27, green: 0.89, blue: 0.98, alpha: 1)))
                .multilineTextAlignment(.center)
                    .frame(width: 250)
                    .frame(height:425)
            }
            }
}.frame(maxWidth: 400)

}
}
