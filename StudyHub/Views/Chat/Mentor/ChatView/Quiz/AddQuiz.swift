//
//  AddQuiz.swift
//  StudyHub
//
//  Created by Andreas on 1/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct AddQuiz: View {
    @State var quiz = Quiz(id: UUID().uuidString, questions: [Question]())
    var body: some View {
        List {
       
        ForEach(self.quiz.questions, id:\.self) { question in
            QuizAddRow(question: question.question)
            
        }
            VStack {
            Spacer()
            Button(action: {
                quiz.questions.append(Question(id: UUID().uuidString, question: "", answers: [String](), answer: "", selected: ""))
            }) {
                Image(systemName: "plus")
            } .buttonStyle(BlueStyle())
            .padding()
        }
        }
    }
    
    }

struct AddQuiz_Previews: PreviewProvider {
    static var previews: some View {
        AddQuiz()
    }
}
