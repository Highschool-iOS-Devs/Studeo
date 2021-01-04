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
    @Binding var group: Groups
    @Binding var points: Int
    var body: some View {
        ZStack {
     Color("Background")
        
        .edgesIgnoringSafeArea(.all)
            
        VStack {
            QuizQuestion(question: $question, i: $i, text: question.question)
            Spacer()
            
            ForEach(question.answers.shuffled(), id: \.self) { a in
                QuizBtn(question: $question, i: $i, text: a, group: $group, points: $points)
            }
                
        }
            }
        }
    
    }

