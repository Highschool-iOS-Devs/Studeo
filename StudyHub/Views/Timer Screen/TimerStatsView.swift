//
//  TimerStatsView.swift
//  StudyHub
//
//  Created by Andreas on 12/28/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import SwiftUICharts
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
    var body: some View {
        GeometryReader { geo in
        ZStack {
        Color.clear
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
            VStack {
                
                if !langauge.isEmpty {
                LineChartView(data: langauge, title: "Foreign Language", legend: "Seconds", dropShadow: false)
                    .padding()
                }
                if !math.isEmpty {
                LineChartView(data: math, title: "Math", legend: "Seconds", dropShadow: false)
                    .padding()
                }
                if !social.isEmpty {
                LineChartView(data: social, title: "Social Studies", legend: "Seconds", form: CGSize(width: geo.size.width/1.1, height: geo.size.width/1.5), dropShadow: false)
                    .padding()
                }
                if !science.isEmpty {
                LineChartView(data: science, title: "Science", legend: "Seconds", dropShadow: false)
                    .padding()
                }
               
                if !english.isEmpty {
                LineChartView(data: english, title: "English", legend: "Seconds", form: CGSize(width: geo.size.width/1.1, height: geo.size.width/1.5), dropShadow: false)
                    .padding()
                }
                if !other.isEmpty {
                LineChartView(data: other, title: "Other", legend: "Seconds", form: CGSize(width: geo.size.width/1.1, height: geo.size.width/1.5), dropShadow: false)
                    .padding()
            }
            }
            }
            }
            
    }
}
}
}
