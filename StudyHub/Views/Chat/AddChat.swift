////
////  AddChat.swift
////  StudyHub
////
////  Created by Andreas Ink on 8/29/20.
////  Copyright © 2020 Dakshin Devanand. All rights reserved.
////
//
//import SwiftUI
//import Firebase
//import FirebaseAuth
//struct AddChat: View {
//    @EnvironmentObject var userData: UserData
//    @State var hasAppeared = false
//    @State var categories = [Categories]()
//    @State var people = [BasicUser]()
//    @State var hasSearched = false
//    @State var matchedPerson = BasicUser(id: "", name: "", count: 0)
//    @State var personCount = -1
//    @State var chatRoom = ""
//    @State var userIDs = ""
//    @State var hasInteractedBefore = false
//    @State var hasFound = false
//    var body: some View {
//        ZStack {
//            Color(.white)
//                .onAppear() {
//                    
//                    
//                    self.categories = [Categories(id: "0", name: "College Apps", count: 0), Categories(id: "1", name: "SAT", count: 1),Categories(id: "2", name: "AP Gov", count: 2), Categories(id: "3", name: "APUSH", count: 3), Categories(id: "4", name: "AP World", count: 4),Categories(id: "5", name: "AP Macro", count: 5)]
//                    self.hasAppeared = true
//            }
//            
//            if self.hasAppeared {
//                ScrollView {
//                    ForEach(categories, id: \.id) { category in
//                        Group {
//                            
//                            AddChatCell(name: category.name)
//                                .onTapGesture {
//                                    
//                                    
//                                    
//                            }
//                            
//                            
//                            
//                            
//                            Divider()
//                            
//                        }
//                    }
//                    Button(action: {
//                        do{
//                            try Auth.auth().signOut()
//                            
//                        }
//                        catch{
//                            print("\(error)")
//                        }
//                    }){
//                        Text("Sign out")
//                    }
//                } .padding(.top, 22)
//            }
//            if hasSearched {
//                ZStack {
//                    
//                    Color(.white)
//                    ChatV2(matchedPerson: self.matchedPerson.name, chatRoom: self.chatRoom, matchedPersonID: self.matchedPerson.id, addChat: true)
//                    
//                }
//            }
//        }
//    }
//    
//}
//
