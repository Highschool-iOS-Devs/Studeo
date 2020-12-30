//
//  QuizView.swift
//  Christmas
//
//  Created by Andreas Ink on 12/19/20.
//

import SwiftUI
import Firebase
struct QuizView: View {
    @State var quiz = Quiz(id: UUID().uuidString, questions: [Question(id: UUID().uuidString, question: "Question", answers: ["A", "B", "C"], answer: "A", selected: ""), Question(id: UUID().uuidString, question: "Question2", answers: ["A", "B", "C"], answer: "A", selected: "")])
    @EnvironmentObject var userData: UserData
    @Binding var i: Int
    @State var isAndreas = true
    @Binding var user: User
    var body: some View {
        ZStack {
            
            QuizDetails(question: $quiz.questions[i], i: $i, user: $user)
           
            
            }
        }
    
    }


