//
//  TimerView.swift
//  StudyHub
//
//  Created by Santiago Quihui on 22/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @Environment(\.colorScheme) var colorScheme
    
   @ObservedObject private var timer = TimerHandler()
    
    var progress: CGFloat {
        let percentage = timer.timePassed / timer.timeGoal
        return CGFloat(percentage)
    }
    
    var body: some View {
        VStack {
            
            HStack {
                Text("Set Timer")
                    .font(Font.custom("Montserrat-SemiBold", size: 34.0))
                    .padding(.top, 64)
                
                //change image to alarm clock symbol
                Image(systemName: "clock")
                    .font(.system(size: 21, weight: .medium))
                    .foregroundColor(Color("clockForeground"))
                    .padding(10)
                    .overlay(Circle()
                        .stroke(Color("clockStroke"), lineWidth: 2))
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
                
                Text("\(fabs(timer.remainingTime), specifier: "%.0f")")
                    .font(Font.custom("Montserrat-Bold", size: 28).monospacedDigit())
                
            }
            .padding(20)
            
            HStack {
                
                Button(action: timer.addSeconds) {
                    Text("-30s")
                }.buttonStyle(SecondsButton())
                
                Button(action: timer.handleTap) {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .animation(nil)
                }
                .buttonStyle(PauseResumeButton())
                
                Button(action: timer.addSeconds) {
                    Text("+30s")
                }.buttonStyle(SecondsButton())
                
            }
            
            
            HStack {
                ForEach(timer.minutes, id: \.self) { minutes in
                    AddMinutesButton(minutes: minutes) {
                        print("\(minutes) selected")
                    }
                    .padding(8)
                }
            }
            
        }
    }//body
    
    
    
    
    
}


class TimerHandler: ObservableObject {
    
    var minutes = [3, 5, 7, 10]
       
    var timer: Timer? = nil
       
    private var firstTimeRun = true
    @Published var isRunning = false
       
    @Published var timePassed = 0.0
    @Published var remainingTime = 0.0
       
    @Published var timeGoal = 0.0
       
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { (tmr) in
            withAnimation {
                guard self.timePassed < self.timeGoal else {
                    self.stopTimer()
                    self.firstTimeRun = true
                    return
                }
                self.isRunning = true
                self.timePassed += 0.2
                self.remainingTime -= 0.2
            }
        })
    }
    
    func stopTimer() {
        timer?.invalidate()
        isRunning = false
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
        if self.isRunning {
            self.stopTimer()
        } else {
            self.startTimer()
        }
    }
    
    func addSeconds() {
        //add missing functionality
    }
    
}


struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
