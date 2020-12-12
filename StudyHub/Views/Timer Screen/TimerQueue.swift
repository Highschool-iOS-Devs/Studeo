//
//  TimerQueue.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/11/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import Foundation
import SwiftUI
struct TimerQueue: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    
 
   
    @State var queueTime = 0.5
    @State var time = 0.0
    @State var start = false
    @State var text = "Finding Opponnets"
    var body: some View {
        ZStack {
            FloatingBlobSubview(duration: 10.0)
            VStack {
                OpponetAnimation(queueTime: $queueTime)
                FindingText(text: $text)
                    .onAppear() {
                        let randomDouble = Double.random(in: 10...20)
                        queueTime = randomDouble
                        let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                            time += 1
                            if queueTime < time {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    start = true
                                }
                                text = "Starting"
                            }
                        }
                    }
}
            if start {
                Color.white
                CompeteView()
            }
        }
    }
}
