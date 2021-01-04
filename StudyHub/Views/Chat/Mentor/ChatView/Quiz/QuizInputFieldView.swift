//
//  QuizInputFieldView.swift
//  StudyHub
//
//  Created by Andreas on 1/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct QuizInputFieldView: View {
    @Binding var text: String
    @State var isQuestion = false
    @State var isAnswer = false
    @State var isPresented = false
    @Binding var quiz: Quiz
    @Binding var question: Question
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                if isQuestion {
                TextField("Question", text: $text)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.horizontal)
                    .frame(height: 44)
                    .autocapitalization(.none)
                   
                   
                } else {
                    TextField("Answer", text: $text)
                        .font(.subheadline)
                        .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                        .padding(.horizontal)
                        .frame(height: 44)
                        .autocapitalization(.none)
                        
                
                    
                    Toggle(isOn: $isAnswer) {
                        Text("Answer?")
                            .font(.custom("Montserrat SemiBold", size: 10))
                    } .padding()
                    .onChange(of: isAnswer) { newValue in
                        if isAnswer {
                            question.answer = text
                            sendData()
                        }
                                }
                }
        
                

            }
            //Divider().padding(.leading, 80).padding(.trailing, 15)
      

        }
        .frame(maxWidth: .infinity)
        .frame(height:136)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 15))
       
        .shadow(color: Color("Primary").opacity(0.1), radius: 15)
        .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)

    }
       

    

    
    func sendData() {
        let db = Firestore.firestore()
        let docRef = db.collection("quizzes/questions/\(quiz.id)")
        do{
            try docRef.document(question.id).setData(from: question)
            
        } catch {
            print("Error writing to database, \(error)")
        }
    }
}
