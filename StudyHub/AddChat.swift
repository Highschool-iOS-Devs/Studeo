//
//  AddChat.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase

struct AddChat: View {
    @EnvironmentObject var userData: UserData
    @State var hasAppeared = false
    @State var categories = [Categories]()
    @State var people = [BasicUser]()
    @State var hasSearched = false
    @State var matchedPerson = BasicUser(id: "", name: "", count: 0)
    var body: some View {
        ZStack {
            Color(.white)
                .onAppear() {
                    
                    self.categories = [Categories(id: "0", name: "College Apps", count: 0), Categories(id: "1", name: "SAT", count: 1),Categories(id: "2", name: "AP Gov", count: 2), Categories(id: "3", name: "APUSH", count: 3), Categories(id: "4", name: "AP World", count: 4),Categories(id: "5", name: "AP Macro", count: 5)]
                    self.hasAppeared = true
            }
            
            if self.hasAppeared {
                ScrollView {
                    ForEach(categories, id: \.id) { category in
                        Group {
                            
                            AddChatCell(name: category.name)
                                .onTapGesture {
                                    
                                    
                                    var db: Firestore!
                                    db = Firestore.firestore()
                                    
                                    db.collection("users").whereField(category.name, isEqualTo: true)
                                        .getDocuments() { (querySnapshot, err) in
                                            if let err = err {
                                                print("Error getting documents: \(err)")
                                            } else {
                                                for document in querySnapshot!.documents {
                                                    let property = document.get("id") as! String
                                                    let property2 = document.get("name") as! String
                                                    
                                                    self.people.append(BasicUser(id: property, name: property2, count: 0))
                                                    print(self.people)
                                                    self.matchedPerson = self.people.randomElement()!
                                                    self.hasSearched = true
                                                }
                                            }
                                    }
                                    
                                    
                                    
                                    
                            }
                            Divider()
                            
                        }
                    }
                } .padding(.top, 22)
            }
            if hasSearched {
                ZStack {
                    
                    Color(.white)
                    ChatV2(matchedPerson: self.matchedPerson.name, chatRoom: "\(UUID())",matchedPersonID: self.matchedPerson.id)
                    
                }
            }
        }
    }
    
}
