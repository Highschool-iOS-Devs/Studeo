//
//  QuizAddRow.swift
//  StudyHub
//
//  Created by Andreas on 1/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct QuizAddRow: View {
    
    @State var answer1 = ""
    @State var answer2 = ""
    @State var answer3 = ""
    @Binding var question: Question
    @Binding var quiz: Quiz
    var body: some View {
        VStack {
            
            QuizInputFieldView(text: $question.question, isQuestion: true, quiz: $quiz, question: $question)
            
            
            Spacer()
            ForEach(self.question.answers.indices) { i in
                QuizInputFieldView(text: $question.answers[i], quiz: $quiz, question: $question)
                
            }
            
        } .padding()
    }
}
