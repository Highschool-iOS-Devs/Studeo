//
//  QuizzesList.swift
//  StudyHub
//
//  Created by Andreas on 1/4/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct QuizzesList: View {
    @State var quizzes = [Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question]())]
    @State var testing = false
    @EnvironmentObject var viewRouter:ViewRouter
    var body: some View {
        if testing {
        ForEach(quizzes, id: \.self) { quiz in
            QuizzesRow(quiz: quiz)
        }
        } else {
            VStack {
                HStack {
                    
                    Button(action: {
                        viewRouter.currentView = .chatList
                    }) {
                        Image(systemName: "xmark")
                    }
                    Spacer()
                }
                Spacer()
            Image("5293")
                .resizable()
                .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .scaledToFill()
                .padding()
            Text("Quizzes Coming Soon!")
                .font(.custom("Montserrat Bold", size: 18))
                .foregroundColor(Color("Text"))
                .padding()
                Spacer()
            } .padding()
        }
}
}

struct QuizzesList_Previews: PreviewProvider {
    static var previews: some View {
        QuizzesList()
    }
}
