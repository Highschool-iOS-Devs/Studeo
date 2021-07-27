//
//  QuizDetails.swift
//  Christmas
//
//  Created by Andreas on 12/19/20.
//

//import SwiftUI
//import Firebase
//import FirebaseFirestoreSwift
//struct QuizDetails: View {
//    @Binding var question: Question
//    @Binding var i: Int
//    @ObservedObject var userData: UserData
//    @Binding var group: Groups
//    @Binding var points: Int
//    @Binding var quiz: Quiz
//    @ObservedObject var quizRouter: QuizRouter
//    @State var users = [User]()
//    var body: some View {
//        ZStack {
//     Color("Background")
//        .onAppear() {
//            loadUserData()
//        }
//        .edgesIgnoringSafeArea(.all)
//            switch quizRouter.currentView {
//            case .question:
//        VStack {
//            QuizQuestion(question: $question, i: $i, text: question.question)
//            Spacer()
//            
//            ForEach(question.answers.shuffled(), id: \.self) { a in
//                QuizBtn(question: $question, i: $i, text: a, group: $group, points: $points, quiz: $quiz)
//            }
//                
//        }
//            case .leaderboard:
//                QuizLeaderboardView(users: $users, group: group, quiz: quiz)
//            }
//        }
//    }
//    func loadUserData() {
//        for user in group.members {
//        let db = Firestore.firestore()
//     let docRef = db.collection("users").document(user)
//        var userList:[User] = []
//        //Get every single document under collection users
//    
//     docRef.addSnapshotListener{ (document, error) in
//         
//                let result = Result {
//                 try document?.data(as: User.self)
//                }
//                switch result {
//                    case .success(let user):
//                        if let user = user {
//                            users.append(user)
//                 
//                        } else {
//                            
//                            print("Document does not exist")
//                        }
//                    case .failure(let error):
//                        print("Error decoding user: \(error)")
//                    }
//     
//            
//        
//        }
//        }
//    }
//    }
//
