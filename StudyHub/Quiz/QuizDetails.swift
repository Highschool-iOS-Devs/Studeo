//
//  QuizDetails.swift
//  Christmas
//
//  Created by Andreas on 12/19/20.
//

import SwiftUI

struct QuizDetails: View {
    @Binding var question: Question
    @Binding var i: Int
    @EnvironmentObject var userData: UserData
    @Binding var user: User
    var body: some View {
        ZStack {
     Color("redL")
        .opacity(0.6)
        .edgesIgnoringSafeArea(.all)
            
        VStack {
            QuizQuestion(question: $question, i: $i, text: question.question)
            Spacer()
            
            ForEach(question.answers, id: \.self) { a in
                QuizBtn(question: $question, i: $i, text: a, user: $user)
            }
                
        }
            }
        }
    
    }

