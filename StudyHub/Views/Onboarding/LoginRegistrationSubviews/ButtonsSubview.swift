//
//  ButtonsSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ButtonsSubview: View {
    
    var mainButtonAction:()->Void = {}
    var secondaryButtonAction:()->Void = {}
    var displayMode:DisplayModes
    
    enum DisplayModes{
        case login
        case registration
    }
    var body: some View {
        VStack(spacing: 35) {
            if displayMode == .login{
            Button(action: mainButtonAction) {
                Text("Sign in")
                    .font(Font.custom("Montserrat-SemiBold", size: 16.0))
            }
            .buttonStyle(BlueStyle())
            .padding(.horizontal, 60)
            Button(action: secondaryButtonAction) {

                Text("Sign Up")
                    .font(Font.custom("Montserrat-SemiBold", size: 16.0))
            }
            .buttonStyle(WhiteStyle())
            .padding(.horizontal, 60)
        }
            else{
                Button(action: mainButtonAction) {

                    Text("Sign Up")
                        .font(Font.custom("Montserrat-SemiBold", size: 16.0))
                }
                .buttonStyle(BlueStyle())
                .padding(.horizontal, 60)
                
                Button(action: secondaryButtonAction) {
                    Text("Sign in")
                        .font(Font.custom("Montserrat-SemiBold", size: 16.0))
                }
                .buttonStyle(WhiteStyle())
                .padding(.horizontal, 60)
            }
    }
}
}
