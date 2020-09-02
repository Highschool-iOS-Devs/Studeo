//
//  ButtonStyles.swift
//  StudyHub
//
//  Created by Santiago Quihui on 22/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI

struct SecondsButton: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .fill(Color("timerseconds"))
                .frame(width: 40, height: 40)
            configuration.label
                .font(.caption)
                .foregroundColor(.white)
        }
        .padding(8)
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

struct PauseResumeButton: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        ZStack {
            Circle()
                .fill(Color("timercontrol"))
                .frame(width: 50, height: 50)
            configuration.label
                .font(.body)
                .foregroundColor(.white)
        }
        .padding(8)
        .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
    
}

struct AddMinutesButton: View {
    
    let minutes: Double
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("\(minutes, specifier: "%.0f") min")
        }
        .buttonStyle(AddMinutesStyle())
    }
}

struct AddMinutesStyle: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(Font.custom("Montserrat-SemiBold", size: 10.0))
            .frame(width: 50, height: 50)
            .background(Color("timerminutes"))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
    }
}

