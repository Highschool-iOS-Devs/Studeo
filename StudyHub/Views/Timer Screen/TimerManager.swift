//
//  TimerManager.swift
//  StudyHub
//
//  Created by Santiago Quihui on 01/09/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

class TimerManager: ObservableObject {
    
    var minutes = [10.0, 20.0, 30.0, 45.0]
    
    private var timer: Timer? = nil
    
    private var firstTimeRun = true
    @Published var isRunning = false
    
    @Published var timePassed = 0.0
    @Published var remainingTime = 0.0
    
    @Published var timeGoal = 0.0
    
    private var startDate = Date()
    private var endDate = Date()
    
    private var hasSavedBefore = false
    
    func setTimer(seconds: Double) {
        stopTimer()
        timePassed = 0
        timeGoal = seconds
        remainingTime = seconds
        startDate = Date()
        endDate = startDate.addingTimeInterval(timeGoal)
        startTimer()
        saveData()
    }
    
    func setTimer(minutes: Double) {
        let seconds = minutes * 60
        setTimer(seconds: seconds)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
            withAnimation {
                guard self.remainingTime > 0 else {
                    self.stopTimer()
                    self.resetTimer()
                    self.saveData()
                    return
                }
                self.timePassed += 0.2
                self.remainingTime -= 0.2
            }
        })
        isRunning = true
        firstTimeRun = false
    }
    
    func stopTimer() {
        timer?.invalidate()
        isRunning = false
        saveData()
    }
    
    func invalidateTimer() {
        timer?.invalidate()
    }
    
    func handleTap() {
        //clean this up if possible
        if self.firstTimeRun {
            withAnimation {
                self.timePassed = 0.0
            }
        } else
            if self.isRunning {
            self.stopTimer()
        } else {
            self.startTimer()
        }
        print(self.timeGoal)
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
    }
    
    func saveData() {
        let defaults = UserDefaults.standard
        defaults.set(isRunning, forKey: "timerIsRunning")
        defaults.set(remainingTime, forKey: "timerRemainingTime")
        defaults.set(timePassed, forKey: "timePassed")
        defaults.set(startDate, forKey: "startDate")
        defaults.set(endDate, forKey: "endDate")
        defaults.set(timeGoal, forKey: "timeGoal")
        defaults.set(firstTimeRun, forKey: "firstTimeRun")
        defaults.set(true, forKey: "hasSaved")
    }
    
    func loadData() {
        let defaults = UserDefaults.standard
        isRunning = defaults.bool(forKey: "timerIsRunning")
        remainingTime = defaults.double(forKey: "timerRemainingTime")
        timePassed = defaults.double(forKey: "timePassed")
        startDate = defaults.object(forKey: "startDate") as? Date ?? Date()
        endDate = defaults.object(forKey: "endDate") as? Date ?? Date()
        timeGoal = defaults.double(forKey: "timeGoal")
        hasSavedBefore = defaults.bool(forKey: "hasSaved")
        if hasSavedBefore {
            firstTimeRun = defaults.bool(forKey: "firstTimeRun")
        }
        startFromLoadedData()
    }
    
    private func startFromLoadedData() {
        guard firstTimeRun == false else { return }
        if isRunning {
            setNewRemainingTime()
            setNewTimePassed()
            startTimer()
        }
    }
    
    private func setNewRemainingTime() {
        let currentDate = Date()
        let newRemainingTime = endDate.timeIntervalSince(currentDate)
        remainingTime = newRemainingTime
    }
    
    private func setNewTimePassed() {
        let currentDate = Date()
        let newTimePassed = currentDate.timeIntervalSince(startDate)
        timePassed = newTimePassed
    }
    
    func resetTimer() {
        timeGoal = 0.0
        remainingTime = 0.0
        timePassed = 0.0
        startDate = Date()
        endDate = Date()
        isRunning = false
        firstTimeRun = true
    }
    
    
}
