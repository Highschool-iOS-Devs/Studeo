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
    @State var quiz =  Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question](), groupID: "")
    var body: some View {
        List {
            QuizTitle(text: $quiz.name)
                .padding()
            ForEach(self.quiz.questions.indices, id: \.self) { i in
                QuizAddRow(question: $quiz.questions[i], quiz: $quiz)
                
            }
            VStack {
                Spacer()
                Button(action: {
                    quiz.questions.append(Question(id: UUID().uuidString, question: "", answers: ["Answer1", "Answer2", "Answer3"], answer: "", selected: "", quizID: quiz.id))
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
        } .onAppear() {
            let db = Firestore.firestore()
            
            let docRef = db.collection("quizzes").document(quiz.id)
            do{
                try docRef.setData(from: quiz)
                
            } catch {
                print("Error writing to database, \(error)")
            }
            
        }
        .onDisappear() {
            let db = Firestore.firestore()
            for question in quiz.questions {
                let docRef = db.collection("quizzes/questions/\(quiz.id)").document(question.id)
                do{
                    try docRef.setData(from: question)
                    
                } catch {
                    print("Error writing to database, \(error)")
                }
            }
        }
    }
}
struct AddQuiz_Previews: PreviewProvider {
    static var previews: some View {
        AddQuiz()
    }
}
