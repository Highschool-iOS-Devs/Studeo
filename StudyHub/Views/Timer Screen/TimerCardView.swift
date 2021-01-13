//
//  TimerCardView.swift
//  StudyHub
//
//  Created by Andreas on 1/13/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TimerCardView: View {
    @State var category: String
    @State var points: Double
    var body: some View {
        ZStack {
            Color("Card")
        HStack {
        Text(category)
            .font(.custom("Montserrat Bold", size: 18, relativeTo: .headline))
            Text("\(points)")
                .font(.custom("Montserrat SemiBold", size: 16, relativeTo: .headline))
    }  .padding()
        }
       
        .clipShape(RoundedRectangle(cornerRadius: 25))
        
        .shadow(color: Color("Primary").opacity(0.1), radius: 15)
        .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
        
    }
}

