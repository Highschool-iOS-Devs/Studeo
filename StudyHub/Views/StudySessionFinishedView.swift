//
//  StudySessionFinishedView.swift
//  StudyHub
//
//  Created by Pablo Quihui on 14/01/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct StudySessionFinishedView: View {
    @Binding var showing: Bool
    @State private var showStack = false
    var body: some View {
        ZStack {
            if showStack {
                BlurView(style: .prominent)
                    .edgesIgnoringSafeArea(.all)
                    .animation(.easeInOut)
            }
            LottieView(name: "34595-confetti-for-ios-and-android")
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        showStack = true
                    }
                }
            
            if showStack {
                VStack {
                    Text("Your study session is over!")
                        .font(Font.custom("Montserrat-SemiBold", size: 20, relativeTo: .headline))
                        .multilineTextAlignment(.center)
                    Button("OK") {
                        self.showing = false
                    }.buttonStyle(BlueStyle())
                    .padding()
                }
                .frame(width: 300, height: 400)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 10, y: 10)
                .animation(.easeInOut)
            }
            
        }
    }
}

struct StudySessionFinishedView_Previews: PreviewProvider {
    static var previews: some View {
        StudySessionFinishedView(showing: .constant(true))
    }
}
