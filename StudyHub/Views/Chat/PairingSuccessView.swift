//
//  PairingSuccess.swift
//  StudyHub
//
//  Created by Andreas on 12/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct PairingSuccess: View {
    @Binding var paired: Bool
    @Binding var chat: Bool
    @State var group: Groups
    var body: some View {
        ZStack {
            LottieView(name: "34595-confetti-for-ios-and-android")
            VStack {
                Text("Pairing Successful!")
                    .font(Font.custom("Montserrat-SemiBold", size: 24.0))
            Button(action: {
               chat = true
            }) {
                Text("Chat")
                    .font(Font.custom("Montserrat-SemiBold", size: 14.0))
            } .buttonStyle(BlueStyle())
            .padding()
            if chat {
                ChatView(group: group)
            }
        }
    }
}
}


