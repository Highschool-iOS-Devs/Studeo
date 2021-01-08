//
//  QuizBtn.swift
//  Christmas
//
//  Created by Andreas Ink on 12/19/20.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct QuizBtn: View {
    @Binding var question: Question
    @Binding var i: Int
    @State var text = "text"
    let screenSize = UIScreen.main.bounds
    @State var questionL = Question2(id: "", question: "", answers: [String](), answer: "", selected: "")
    @EnvironmentObject var userData: UserData
    @State var image = UIImage()
    @Binding var group: Groups
    @Binding var points: Int
    var body: some View {
      
        Button(action: {
            question.selected = text
            questionL.selected = text
            print(question.selected)
            if question.selected == question.answer {
              i += 1
                let db = Firestore.firestore()
              //  db.collection("quizzes").document("\(group.id)/\(userData.userID)").updateData ([
               //     "points":  points + 1,
                    
               // ]) { err in
                //    if let err = err {
                 //       print("Error updating document: \(err)")
                 //   } else {
                 //       print("Document successfully updated")
                    }
               // }
           // }
            
          
            
        }) {
            Text(text)
                .font(.custom("Montserrat Bold", size: 18))
                .padding(.horizontal, screenSize.width/3)
             //   .foregroundColor(questionL.selected != "" ? Color("Primary") : .white)
        } //.disabled(question.selected != "" ? true : false)
        
        .buttonStyle(BlueStyle())
        .padding()
    }
    func saveScore() {
        
    }
    }

