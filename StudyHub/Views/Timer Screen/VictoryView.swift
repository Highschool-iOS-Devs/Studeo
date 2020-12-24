//
//  VictoryView.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/12/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct VictoryView: View {
    var body: some View {
        GeometryReader { geo in
        ZStack {
            Color(.white)
            LottieView(name: "30111-confetti-animation")
                .frame(width: geo.size.width)
            VStack {
                Text("Amazing Work!")
                    .font(.custom("Montserrat-bold", size: 28))
                Text("You beat everyone in the study group and studied the longest!")
                    .font(.custom("Montserrat-semibold", size: 22))
                    .multilineTextAlignment(.center)
                Spacer()
                
                Button(action: {
                   
                    
                }) {
                    Text("Home")
                        .font(.headline)
                        .multilineTextAlignment(.trailing)
                    
                    
                    
                } .buttonStyle(BlueStyle())
            } .padding()
        } .frame(width: geo.size.width)
    }
}
}
struct VictoryView_Previews: PreviewProvider {
    static var previews: some View {
        VictoryView()
    }
}
