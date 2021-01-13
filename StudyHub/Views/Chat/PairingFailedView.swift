//
//  PairingFailedView.swift
//  StudyHub
//
//  Created by Andreas on 1/13/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct PairingFailedView: View {
    @Binding var paired: Bool
    var body: some View {
        VStack {
        Text("We've hit an error :(")
            .font(Font.custom("Montserrat-SemiBold", size: 24, relativeTo: .headline))
            Button(action: {
               paired = false
            }) {
                Text("Try Again")
                    .font(Font.custom("Montserrat-SemiBold", size: 14, relativeTo: .headline))
            } .buttonStyle(BlueStyle())
            .padding()
        }
    }
}

