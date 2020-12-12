//
//  CompeteView.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/12/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct CompeteView: View {
    let data = (0...3).map { "Item \($0)" }
    let columns = [
        GridItem(.flexible(minimum: 80, maximum: 100)),
        GridItem(.flexible(minimum: 80, maximum: 100)),
        
    ]
    @State var showtimer = true
    var body: some View {
        VStack {
            LazyVGrid(columns: columns, spacing: 20) {
              
                ForEach(Array(data.enumerated()), id: \.element) { i, item in
                    ProfilePic(name: "", size: 75, isTimer: true)
                            .transition(.slide)
                            
                    
            }
            }
            TimerView(showingView: $showtimer)
                
        }
    }
}

struct CompeteView_Previews: PreviewProvider {
    static var previews: some View {
        CompeteView()
    }
}
