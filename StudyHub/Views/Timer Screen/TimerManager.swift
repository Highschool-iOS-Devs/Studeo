//
//  TimerManager.swift
//  StudyHub
//
//  Created by Santiago Quihui on 01/09/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase

class TimerManager: ObservableObject {
    
    var userData: UserData = UserData.shared
    
    var minutes = [4, 90, 120, 180]
    
    private var timer: Timer? = nil
    
    private var firstTimeRun = true
    @Published var isRunning = false
    
    @Published var timePassed = 0.0
    @Published var remainingTime = 0.0
    
    @Published var timeGoal = 0.0
    
    private var startDate = Date()
    var endDate = Date()
    
    private var pauseDate = Date()
    private var resumeDate = Date()
    
    private var totalTimePassed = 0.0
    
    private var hasSavedBefore = false
    
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            withAnimation(.linear(duration: 1.0)) {
                guard self.remainingTime > 0 else {
                    self.endTimer()
                    return
                }
                self.timePassed += 1.0
                self.remainingTime -= 1.0
            }
        })
        isRunning = true
        firstTimeRun = false
        saveToUD()
    }
    
    func setTimer(seconds: Double) {
        stopTimer()
        timePassed = 0
        timeGoal = seconds
        remainingTime = seconds
        startDate = Date()
        endDate = startDate.addingTimeInterval(timeGoal)
        startTimer()
    }
    
    func setTimer(minutes: Int) {
        let seconds = minutes * 60
        setTimer(seconds: Double(seconds))
    }
    
    func stopTimer() {
        timer?.invalidate()
        isRunning = false
    }
    
    func endTimer() {
        stopTimer()
        if timePassed > 300 {
            //only give credit if study time is longer than 5 minutes
            self.totalTimePassed += self.timePassed
            saveToFB()
        }
        resetTimer()
        saveToUD()
    }
    
    func resetTimer() {
        timeGoal = 0.0
        timePassed = 0.0
        isRunning = false
        remainingTime = 0.0
        startDate = Date()
        endDate = Date()
        firstTimeRun = true
    }
    
    func handleTap() {
        if self.firstTimeRun {
            withAnimation {
                self.timePassed = 0.0
            }
        } else if self.isRunning {
            self.stopTimer()
            self.pauseDate = Date()
            saveToUD()
        } else {
            self.startTimer()
            self.resumeDate = Date()
            let timePaused = resumeDate.timeIntervalSince(pauseDate)
            endDate.addTimeInterval(timePaused)
        }
    }
    
    func add(_ seconds: Double) {
        remainingTime += seconds
        timeGoal += seconds
        if firstTimeRun {
            startDate = Date()
            endDate = startDate.addingTimeInterval(timeGoal)
            startTimer()
        } else {
            endDate.addTimeInterval(seconds)
        }
    }
    
    func substract(_ seconds: Double) {
        let newRemainingTime = remainingTime - seconds
        guard newRemainingTime >= 0 else {
            remainingTime = 0
            timeGoal = 0
            return
        }
        remainingTime = newRemainingTime
        timeGoal -= seconds
        endDate.addTimeInterval(-seconds)
    }
    
    func saveToUD() {
        let defaults = UserDefaults.standard
        defaults.set(isRunning, forKey: "timerIsRunning")
        defaults.set(remainingTime, forKey: "timerRemainingTime")
        defaults.set(timePassed, forKey: "timePassed")
        defaults.set(endDate, forKey: "endDate")
        defaults.set(timeGoal, forKey: "timeGoal")
        defaults.set(firstTimeRun, forKey: "firstTimeRun")
        defaults.set(true, forKey: "hasSaved")
        defaults.set(pauseDate, forKey: "pauseDate")
        defaults.set(resumeDate, forKey: "resumeDate")
        defaults.set(totalTimePassed, forKey: "totalTime")
        hasSavedBefore = true
        defaults.set(hasSavedBefore, forKey: "hasSaved")
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        isRunning = defaults.bool(forKey: "timerIsRunning")
        let remaining = defaults.double(forKey: "timerRemainingTime")
        timePassed = defaults.double(forKey: "timePassed")
        endDate = defaults.object(forKey: "endDate") as? Date ?? Date()
        timeGoal = defaults.double(forKey: "timeGoal")
        
        pauseDate = defaults.object(forKey: "pauseDate") as? Date ?? Date()
        resumeDate = defaults.object(forKey: "resumeDate") as? Date ?? Date()
        hasSavedBefore = defaults.bool(forKey: "hasSaved")
        if hasSavedBefore {
            firstTimeRun = defaults.bool(forKey: "firstTimeRun")
            totalTimePassed = defaults.double(forKey: "totalTime")
        } else {
            getStudyHoursFromFB()
        }
        
        startFromLoadedData(remainingTime: remaining)
    }
    
   
    
    
    
    
    private func saveToFB() {
        let db = Firestore.firestore()
        let studyHours = totalTimePassed / 3600
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        let studyDate = dateFormatter.string(from: endDate)
        let timerData: [String: Any] = [
            "studyDate" : studyDate,
            "studyHours" : studyHours
        ]
        db.collection("users").document(userData.userID).updateData(timerData) { error in
            if let error = error {
                print("Error updating data: \(error.localizedDescription)")
            } else {
                print("Success updating data")
            }
        }

    }
    
    private func getStudyHoursFromFB() {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userData.userID)

        ref.getDocument { (document, error) in
            guard let document = document else {
                print("Error loading data: \(error)")
                return
            }
            let data = document.data()?["studyHours"] as? Double
            
            self.totalTimePassed = data ?? 0

        }
    }
    
    private func setNewRemainingTime() {
        let currentDate = Date()
        let newRemainingTime = endDate.timeIntervalSince(currentDate)
        let newTimePassed = timeGoal - newRemainingTime
        guard newRemainingTime > 0 else {
            remainingTime = 0
            timePassed = timeGoal
            return
        }
        remainingTime = newRemainingTime
        withAnimation {
            timePassed = newTimePassed
        }
        
    }
    
    func startFromLoadedData(remainingTime: Double) {
        guard firstTimeRun == false else { return }
        if isRunning {
            setNewRemainingTime()
            startTimer()
        } else {
            self.remainingTime = remainingTime
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    
}
