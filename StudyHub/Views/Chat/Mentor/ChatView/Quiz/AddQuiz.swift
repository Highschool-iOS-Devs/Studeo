//
//  AddQuiz.swift
//  StudyHub
//
//  Created by Andreas on 1/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct AddQuiz: View {
    @State var quiz = Quiz(id: UUID().uuidString, questions: [Question]())
    var body: some View {
        List {
       
            ForEach(self.quiz.questions) { question in
            QuizAddRow(question: question, quiz: $quiz)
            
        }
            VStack {
            Spacer()
            Button(action: {
                quiz.questions.append(Question(id: UUID().uuidString, question: "", answers: ["Answer1", "Answer2", "Answer3"], answer: "", selected: ""))
                let db = Firestore.firestore()
                for question in quiz.questions {
                    let docRef = db.collection("quizzes/questions/\(quiz.id)").document(question.id)
                do{
                    try docRef.setData(from: question)
                    
                } catch {
                    print("Error writing to database, \(error)")
                }
                }
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
