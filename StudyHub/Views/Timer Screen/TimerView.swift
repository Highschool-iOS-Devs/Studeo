//
//  TimerView.swift
//  StudyHub
//
//  Created by Santiago Quihui on 22/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    
    @State private var minutesToAdd = [3, 5, 7, 10]
    
    @State private var timer: Timer? = nil
    
    @State private var firstTimeRun = true
    @State private var timerIsRunning = false
    
    @State private var timePassed = 0.0
    @State private var remainingTime = 0.0
    
    @State private var timeGoal = 0.0
    
    var progress: CGFloat {
        let percentage = self.timePassed / 30.0
        return CGFloat(percentage)
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Set Timer")
                    .font(Font.custom("Montserrat-SemiBold", size: 34.0))
                    .padding(.top, 64)
                    
                
                Image("clock")
                    .resizable()
                    .frame(width: 34, height: 34)
                    .padding(.top, 64)

            }
            
            ZStack {
                
                Circle()
                    .stroke(Color("customTimerGray"), lineWidth: 10)
                    .frame(width: 200, height: 200)
                
                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(Color("customTimerBlue"), lineWidth: 10)
                    .frame(width: 200, height: 200)
                    .rotationEffect(.degrees(-90))
                
                Text("\(fabs(remainingTime), specifier: "%.0f")")
                    .font(Font.custom("Montserrat-Bold", size: 28).monospacedDigit())
                
            }
            .padding(20)
            
            HStack {
                
                Button(action: addSeconds) {
                    Text("-30s")
                }.buttonStyle(SecondsButton())
                
                Button(action: handleTap) {
                    Image(systemName: timerIsRunning ? "pause.fill" : "play.fill")
                }.buttonStyle(PauseResumeButton())
                
                Button(action: addSeconds) {
                    Text("+30s")
                }.buttonStyle(SecondsButton())
                
            }
            
            
            HStack {
                ForEach(self.minutesToAdd, id: \.self) { minutes in
                    AddMinutesButton(minutes: minutes) {
                        print("\(minutes) selected")
                    }
                    .padding(8)
                }
            }
            
        }
    }//body
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (tmr) in
            withAnimation {
                guard self.timePassed < self.timeGoal else {
                    self.stopTimer()
                    self.firstTimeRun = true
                    return
                }
                self.timerIsRunning = true
                self.timePassed += 0.2
                self.remainingTime -= 0.2
            }
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        timerIsRunning = false
    }
    
    func addSeconds() {
        //add missing functionality
    }
    
    func handleTap() {
        //clean this up if possible
        if self.firstTimeRun {
            withAnimation {
                self.timePassed = 0.0
            }
            //add functionality to set time goal depending on user selection
            self.timeGoal = 30.0
            self.remainingTime = self.timeGoal
            self.firstTimeRun = false
        }
        if self.timerIsRunning {
            self.stopTimer()
        } else {
            self.startTimer()
        }
    }
}



struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
