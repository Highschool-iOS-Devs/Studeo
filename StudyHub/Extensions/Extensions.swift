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
            .background(configuration.isPressed ? Color.buttonPressedBlue:Color.buttonBlue)
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
            .foregroundColor(Color.buttonBlue)
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
            .frame(width: 250, height: 10)
            .font(Font.custom("Montserrat-Regular", size: 15.0))
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10.0)
    }
}

struct SearchTextField: TextFieldStyle {
//    var colorScheme: ColorScheme
    
    func _body(configuration: TextField<_Label>) -> some View {
        HStack {
            configuration
            Spacer()
            Divider()
            Button(action: {
                
            }) {
                Image("dropdown")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .scaledToFit()
            }
        }
        .font(Font.custom("Montserrat-Regular", size: 15.0))
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10.0)
        .frame(height: 25)
        .padding(.top, 22)
        .padding([.horizontal, .bottom], 44)
    }
}


//NOTE: - Custom colors

extension Color {
    public static var buttonBlue: Color {
        return Color(#colorLiteral(red: 0, green: 0.6, blue: 1, alpha: 1))
    }
    public static var buttonPressedBlue: Color {
        return Color(#colorLiteral(red: 0, green: 0.4666666667, blue: 1, alpha: 1))
    }
    public static var gradientLight: Color {
        return Color(#colorLiteral(red: 0, green: 0.9333333333, blue: 1, alpha: 1))
       }
    public static var gradientDark: Color {
        return Color(#colorLiteral(red: 0, green: 0.5843137255, blue: 1, alpha: 1))
    }
}
