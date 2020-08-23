//
//  Extensions.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

//NOTE: - Styling for buttons

struct BlueStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(configuration.isPressed ? Color.buttonPressedBlue:Color.customBlue)
            .cornerRadius(10)
            .shadow(radius: 5)
            .scaleEffect(configuration.isPressed ? 0.9:1.0)
    }
}

struct WhiteStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.customBlue)
            .background(configuration.isPressed ? Color.buttonPressedBlue:Color.white)
            .cornerRadius(10)
            .shadow(radius: 5)
            .scaleEffect(configuration.isPressed ? 0.9:1.0)
    }
}

//NOTE: - Custom Text Field

struct CustomTextField: TextFieldStyle {
    func _body(configuration: TextField<_Label>) -> some View {
        configuration
            .font(Font.custom("Montserrat-Regular", size: 15.0))
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10.0)
    }
}

//NOTE: - Custom colors

extension Color {
    public static var customBlue: Color {
        return Color(red: 0.0/255.0, green: 153.0/255.0, blue: 255.0/255.0)
    }
    public static var buttonPressedBlue: Color {
        return Color(red: 0.0/255.0, green: 119.0/255.0, blue: 255.0/255.0)
    }
    public static var light: Color {
           return Color(red: 0.0/255.0, green: 119.0/255.0, blue: 255.0/255.0)
       }
}
