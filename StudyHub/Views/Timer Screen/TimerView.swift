//
//  TimerView.swift
//  StudyHub
//
//  Created by Santiago Quihui on 22/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    @StateObject private var timer = TimerManager()
    
    @Binding var showingView: Bool
   
    var notificationID: String = "timerEnded"
    
    
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
    @State var category = "Math"
    @State var stats = false
    
    @Binding var timerLog: [TimerLog]
    var body: some View {
        ZStack {
        VStack(spacing: 0) {
            
            HStack {
                Button(action: {
                    stats.toggle()
                }) {
                    Image(systemName: "chart.bar")
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        self.showingView = false
                       
                    }
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(Color("Text"))
                        .font(.body)
                }
            }
            .padding()
           
            TimerSelectView(category: $category)
                .onChange(of: category, perform: { value in
                    timer.category = category
                })
                
                .padding(.vertical)
            
            HStack {
                Text("Set Timer")
                    .font(Font.custom("Montserrat-SemiBold", size: 34.0))
                
                Image(systemName: "clock")
                    .font(.system(size: 21, weight: .medium))
                    .foregroundColor(Color("clockForeground"))
                    .padding(10)
                    .overlay(Circle()
                        .stroke(Color("clockStroke"), lineWidth: 2))
            }
            .onAppear() {
               // self.timer.add(600)
                if !timer.isRunning  {
                //    self.timer.add(600)
                }
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
                    
                    .font(Font.custom("Montserrat-Bold", size: 28, relativeTo: .subheadline).monospacedDigit())
                    .animation(nil)
                
            }
            .padding(20)
            
            HStack {
                
                Button(action: {
                    self.timer.substract(30)
                    addNotification()
                }) {
                    Text("-30s")
                }.buttonStyle(SecondsButton())
                
                Button(action: {
                    timer.handleTap()
                    if timer.isRunning {
                        addNotification()
                    } else {
                        removeNotification()
                    }
                }) {
                    Image(systemName: timer.isRunning ? "pause.fill" : "play.fill")
                        .animation(nil)
                }
                .buttonStyle(PauseResumeButton())
                .contextMenu {
                    Button(action: {
                        self.timer.endTimer()
                        removeNotification()
                    }) {
                        Text("Stop")
                        Image(systemName: "stop.circle")
                    }
                    
                }
                
                Button(action: {
                    self.timer.add(30)
                    addNotification()
                }) {
                    Text("+30s")
                }.buttonStyle(SecondsButton())
                
            }
            
            
            HStack {
                ForEach(timer.minutes, id: \.self) { minutes in
                    AddMinutesButton(minutes: minutes) {
                        print("\(minutes) selected")
                        self.timer.setTimer(minutes: minutes)
                        addNotification()
                    }
                    .padding(8)
                }
            }
           
        }
        .padding()
        .background(Color(.systemBackground))
        .frame(maxWidth: 400)
        .cornerRadius(20)
        .padding()
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
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
            if stats {
                TimerStatsView(timerLog: $timerLog, stats: $stats)
            }
        }
        
    }//body
    
   
    func addNotification() {
        let center = UNUserNotificationCenter.current()
        
        let addNotifRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Study session is over"
            content.subtitle = "Timer ended"
            
            
            let endDate = timer.endDate
            let calendar = Calendar.current
            let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: endDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            
            let request = UNNotificationRequest(identifier: self.notificationID, content: content, trigger: trigger)
            
            center.add(request)
//            print("Notification added")
        }
        
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
//                print("Authorized")
                addNotifRequest()
            } else {
//                print("Not authorized yet")
                center.requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
                    if success {
//                        print("Success")
                        addNotifRequest()
                    } else {
//                        print("Error")
                        if let error = error {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [notificationID])
//        print("Notification removed")
    }
    
}





