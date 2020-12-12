//
//  CompeteView.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/12/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct CompeteView: View {
    @State var data = (0...3).map { "Item \($0)" }
    let columns = [
        GridItem(.flexible(minimum: 80, maximum: 100)),
        GridItem(.flexible(minimum: 80, maximum: 100)),
        
    ]
    @State var showtimer = true
    @State var i = 0
    @State var victory = false
    var body: some View {
        ZStack {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
              
                ForEach(Array(data.enumerated()), id: \.element) { i, item in
                    ProfilePic(name: "", size: 75, isTimer: true)
                            .transition(.slide)
                            
                    
            }
            }
            TimerView(showingView: $showtimer)
                .onAppear() {
                    let timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        if data.isEmpty {
                            victory = true
                        }
                    }
                    //let randomTime = Double.random(in: 300...1800)
                    let randomTime = Double.random(in: 10...30)
                    let randomTime2 = Double.random(in: 10...30)
                    let randomTime3 = Double.random(in: 10...30)
                    let randomTime4 = Double.random(in: 10...30)
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) {
                        let random = Int.random(in: 0...i)
                    data.remove(at: random)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomTime2) {
                        let random = Int.random(in: 0...i)
                    data.remove(at: random)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomTime3) {
                        let random = Int.random(in: 0...i)
                    data.remove(at: random)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomTime4) {
                        let random = Int.random(in: 0...i)
                    data.remove(at: random)
                    }
                }
                }
        if victory {
        VictoryView()
            .padding()
        }
        }
        }
   
    }


struct CompeteView_Previews: PreviewProvider {
    static var previews: some View {
        CompeteView()
    }
}
