//
//  QuizzesRow.swift
//  StudyHub
//
//  Created by Andreas on 1/4/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct QuizzesRow: View {
    @State var quiz =  Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question](), groupID: "")
    @Binding var quizzing: Quiz
    @Binding var viewQuiz: Bool
    var body: some View {
        HStack {
            Text(quiz.name)
                .font(.custom("Montserrat Bold", size: 18))
            Spacer()
            Button(action: {
                quizzing = quiz
                viewQuiz = true
            }) {
                Text("Start")
            } .buttonStyle(BlueStyle())
            .frame(width: 100)
        } .padding()
        .frame(width: 250)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        
        .shadow(color: Color("Primary").opacity(0.1), radius: 15)
        .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
    }
}

