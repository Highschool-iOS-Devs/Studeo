//
//  QuizTitle.swift
//  StudyHub
//
//  Created by Andreas on 1/8/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct QuizTitle: View {
    @Binding var text: String
    var body: some View {
        VStack {
            TextField("Title", text: $text)
                .font(.subheadline)
                .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                .padding(.horizontal)
                .frame(height: 44)
                .autocapitalization(.none)
            
        } .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 15))
       
        .shadow(color: Color("Primary").opacity(0.1), radius: 15)
        .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
    }
}

