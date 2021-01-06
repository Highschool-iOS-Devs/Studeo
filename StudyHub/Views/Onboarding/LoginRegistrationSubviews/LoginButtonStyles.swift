//
//  CustomButtonStyles.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct BlueStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.buttonBlue)
            //.background(configuration.isPressed ? Color.buttonPressedBlue:Color.buttonBlue)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color.buttonBlue.opacity(0.3), radius: 10)
            .shadow(color: Color.buttonBlue.opacity(configuration.isPressed ? 0 : 0.6), radius: 3, x: 3, y: 3)
            //.animation(.default)
            .scaleEffect(configuration.isPressed ? 1.1 : 1.0)
            .animation(.easeOut(duration: 0.2))

    }
}

struct WhiteStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.buttonBlue)
            .background(Color.white)
            //.background(configuration.isPressed ? Color.buttonPressedBlue:Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(color: Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)).opacity(0.3), radius: 10)
            .shadow(color: Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)).opacity(configuration.isPressed ? 0 : 0.4), radius: 3, x: 3, y: 3)
            .scaleEffect(configuration.isPressed ? 1.1:1.0)
            .animation(Animation.easeOut(duration: 0.2))

    }
}
