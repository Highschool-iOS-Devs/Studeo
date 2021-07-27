//
//  QuizView.swift
//  Christmas
//
//  Created by Andreas Ink on 12/19/20.
//

//import SwiftUI
//import Firebase
//struct QuizView: View {
//    @State var quiz = Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question](), groupID: "")
//    @ObservedObject var userData: UserData
//    @Binding var i: Int
//    @State var isAndreas = true
//    @Binding var group: Groups
//    @State var points = 0
//    var body: some View {
//        ZStack {
//            
//            QuizDetails(userData: userData, question: $quiz.questions[i], i: $i, group: $group, points: $points, quiz: $quiz)
//           
//                .onAppear() {
//                    print(quiz.questions.count)
//                }
//            }
//        }
//    
//    }
//
//
