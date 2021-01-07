//
//  QuizzesList.swift
//  StudyHub
//
//  Created by Andreas on 1/4/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct QuizzesList: View {
    @State var quizzes = [Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question](), groupID: "")]
    @State var testing = true
    @Binding var group: Groups
    @EnvironmentObject var viewRouter:ViewRouter
    var body: some View {
        ZStack {
            Color("Background")
                .onAppear() {
                    self.loadQuizzes(){ userData in
                        quizzes = userData ?? []
                        for i in quizzes.indices {
                            self.loadQuestions(id: quizzes[i].id, i: i)
                      
                        }
                    }
                }
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
    func loadQuizzes(performAction: @escaping ([Quiz]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("users").whereField("groupID", arrayContains: group.groupID)
        var groupList:[Quiz] = []
        //Get every single document under collection users
        
        docRef.getDocuments{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
                for document in querySnapshot.documents{
                    let result = Result {
                        try document.data(as: Quiz.self)
                    }
                    switch result {
                    case .success(let user):
                        if var user = user {
                            
                            groupList.append(user)
                            
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                    
                    
                }
            }
            else{
                performAction(nil)
            }
            performAction(groupList)
        }
        
        
    }
    func loadQuestions(id: String, i: Int) {
        let db = Firestore.firestore()
        for quiz in quizzes {
        let docRef = db.collection("users").whereField("quizID", arrayContains: id)
        var groupList:[Question] = []
        //Get every single document under collection users
        
        docRef.getDocuments { (querySnapshot, error) in
            if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
                for document in querySnapshot.documents{
                    let result = Result {
                        try document.data(as: Question.self)
                    }
                    switch result {
                    case .success(let user):
                        if var user = user {
                            
                            quizzes[i].questions.append(user)
                            
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                    
                    
                }
            }
            else{
                
            }
            
        }
        
        }
    }
}

