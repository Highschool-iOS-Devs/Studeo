//
//  OpponetAnimation.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/11/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct OpponetAnimation: View {
    @Binding var queueTime: Double
    @State var animating = false
    @State var randomPos = [Double]()
    let data = (0...3).map { "Item \($0)" }
    let columns = [
        GridItem(.flexible(minimum: 80, maximum: 100)),
        GridItem(.flexible(minimum: 80, maximum: 100))
    ]
    @State var hasLoaded = false
    @State var i = 0
    var body: some View {
        ZStack {
            Color.white
                .onAppear() {
                    for d in data {
                        
                        let randomDouble = Double.random(in: Double(i)*100 ... Double(i)*1000)
                    randomPos.append(randomDouble)
                        hasLoaded = true
                        i += 1
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeOut(duration: queueTime)) {
                        
                    animating.toggle()
                        }
                
                }
                }
            if hasLoaded {
            LazyVGrid(columns: columns, spacing: 20) {
              
                ForEach(Array(data.enumerated()), id: \.element) { i, item in
                        ProfilePic(name: "", size: 100, isTimer: true)
                            .offset(y: animating ?  CGFloat(0) : CGFloat(randomPos[i]))
                            .transition(.slide)
                            .onAppear() {
                              
                            }
                    
            }
            }
            }
        }
    }
}

