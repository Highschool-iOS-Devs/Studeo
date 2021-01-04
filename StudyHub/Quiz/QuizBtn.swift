//
//  QuizBtn.swift
//  Christmas
//
//  Created by Andreas Ink on 12/19/20.
//

import SwiftUI
import Firebase
struct QuizBtn: View {
    @Binding var question: Question
    @Binding var i: Int
    @State var text = "Santa"
    let screenSize = UIScreen.main.bounds
    @State var questionL = Question(id: "", question: "", answers: [String](), answer: "A", selected: "")
    @EnvironmentObject var userData: UserData
    @Binding var user: User
    var body: some View {
      
        Button(action: {
            question.selected = text
            questionL.selected = text
            print(question.selected)
            if question.selected == question.answer {
              
            }
        }) {
            Text(text)
                .font(.custom("Montserrat Bold", size: 18))
                .padding(.horizontal, screenSize.width/3)
                .foregroundColor(questionL.selected != "" ? Color("gold") : .white)
        } .disabled(question.selected != "" ? true : false)
        
        .buttonStyle(BlueStyle())
        .padding()
    }
    func saveScore() {
        
    }
    }

