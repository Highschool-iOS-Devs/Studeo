//
//  TimerView.swift
//  StudyHub
//
//  Created by Santiago Quihui on 22/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TimerView: View {
    @ObservedObject private var timer = TimerManager()
    
    @Binding var showingView: Bool
    @GestureState var tap = false
    
    var progress: CGFloat {
        let percentage = timer.timePassed / timer.timeGoal
        return CGFloat(percentage)
    }
    
    var formattedTime: String {
        let seconds = TimeInterval(fabs(timer.remainingTime))
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: seconds) ?? "N/N"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button(action: {
                        self.showingView = false
                    
                }) {
                    Image(systemName: "xmark")
                        .font(.body)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.black)
                        .clipShape(Circle())
                        .scaleEffect(tap ? 1.2 : 1)
                        .gesture(
                            LongPressGesture(minimumDuration: 1.5).updating($tap){currentState, gestureState, transaction in
                                gestureState = currentState
                            }
                            .onEnded{value in
                                self.showingView = false
                            }
                        )
                        .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
                        
                }
            }
            .padding()
            
            HStack {
                Text("Set Timer")
                    .font(Font.custom("Montserrat-SemiBold", size: 34.0))
                
                //change image to alarm clock symbol
                Image(systemName: "clock")
                    .font(.system(size: 21, weight: .medium))
                    .foregroundColor(Color("clockForeground"))
                  
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
                
                Text(formattedTime)
                    .font(Font.custom("Montserrat-Bold", size: 28).monospacedDigit())
                    .animation(nil)
                
            }
            .padding(20)
            
            HStack {
                
                Button(action: {
                    self.timer.substract(30)
                }) {
                    Text("-30s")
                }.buttonStyle(SecondsButton())
                
                Button(action: {
                    timer.handleTap()
                }) {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .animation(nil)
                }
                .buttonStyle(PauseResumeButton())
                .contextMenu {
                    Button(action: {
                        self.timer.endTimer()
                    }) {
                        Text("Stop")
                        Image(systemName: "stop.circle")
                    }
                    
                    Button(action: {
                        self.timer.resetTimer()
                    }) {
                        Text("Reset")
                        Image(systemName: "arrow.counterclockwise")
                    }
                }
                
                Button(action: {
                    self.timer.add(30)
                }) {
                    Text("+30s")
                }.buttonStyle(SecondsButton())
                
            }
            
            
            HStack {
                ForEach(timer.minutes, id: \.self) { minutes in
                    AddMinutesButton(minutes: minutes) {
                        print("\(minutes) selected")
                        self.timer.setTimer(minutes: minutes)
                    }
                    .padding(8)
                }
            }
            
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .padding()
        .shadow(radius: 10)
        .onAppear {
            self.timer.loadData()
        }
        .onDisappear {
            self.timer.saveToUD()
            self.timer.stopTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: { _ in
            self.timer.saveToUD()
            self.timer.stopTimer()
        })
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: { _ in
            self.timer.loadData()
        })
    }//body
    
    
}




struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(showingView: .constant(true))
    }
}

