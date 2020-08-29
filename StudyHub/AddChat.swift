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
    @State var hasInteractedBefore = false
    //  @State var categories = [Categories]()
    @State var people = [BasicUser]()
    @State var hasSearched = false
    @State var hasFound = false
    @State var matchedPerson = BasicUser(id: "", name: "", count: 0)
    @State var personCount = -1
    @State var num = -1
    @State var chatRoom = ""
    @State var auth = false
    var body: some View {
        ZStack {
            Color(.white)
                .onAppear() {
                    
                    if Auth.auth().currentUser?.uid == nil {
                        self.auth = true
                    } else {
                        
                        print(self.userData.userID)
                        var db: Firestore!
                        db = Firestore.firestore()
                        db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
                            if let document = document, document.exists {
                                
                                let id = document.get("id") as! String
                                db.collection("users")
                                    .getDocuments() { (querySnapshot, err) in
                                        if let err = err {
                                            print("Error getting documents: \(err)")
                                        } else {
                                            for document in querySnapshot!.documents {
                                                let property = document.get("id") as! String
                                                let property2 = document.get("name") as! String
                                                
                                                let property3 = document.get("hasInteractedWith") as! [String]
                                                
                                                if !property3.contains(id) {
                                                    self.personCount += 1
                                                    self.people.append(BasicUser(id: property, name: property2, count: self.personCount))
                                                }
                                                
                                                //
                                            }
                                        }
                                        self.hasAppeared = true
                                        print("appear")
                                }
                            }
                        }
                    }
            }
            
            
            
            if self.hasAppeared {
                Color(.white)
                ScrollView {
                    ForEach(people, id: \.id) { person in
                        Group {
                            
                            AddChatCell(name: person.name)
                                .onTapGesture {
                                    self.personCount = person.count
                                    self.matchedPerson = self.people[self.personCount]
                                    
                                    self.hasSearched = true
                                    
                                    
                                    
                                    
                            }
                            Divider()
                            
                        }
                    }
                } .padding(.top, 22)
            }
            if hasSearched {
                ZStack {
                    
                    Color(.white)
                        .onAppear() {
                            var db: Firestore!
                            db = Firestore.firestore()
                            
                            print("hi" + self.people[self.personCount].id)
                            print(self.matchedPerson.id)
                            db.collection("users").document(self.matchedPerson.id).getDocument { (document, error) in
                                if let document = document, document.exists {
                                    
                                    let property = document.get("id") as! String
                                    let property2 = document.get("name") as! String
                                    var property3 = document.get("hasInteractedWith") as! [String]
                                    print(property)
                                    var property4 = document.get("hasInteractedWith2") as! [String]
                                    property3.append(Auth.auth().currentUser!.uid)
                                    //for property in property3 {
                                    
                                    // if property == Auth.auth().currentUser!.uid {
                                    
                                    //      property3.remove(at: self.num)
                                    //      property4.remove(at: self.num)
                                    //}
                                    //           self.num += 1
                                    //}
                                    
                                    db.collection("users").document(property).setData([ "hasInteractedWith": property3], merge: true)
                                    self.chatRoom = "\(UUID())"
                                    property4.append(self.chatRoom)
                                    db.collection("users").document(property).setData([ "hasInteractedWith2": property4], merge: true)
                                    
                                    
                                    
                                    
                                    
                                    if property3.contains(self.userData.userID) {
                                        self.hasInteractedBefore = true
                                    }
                                    else {
                                        self.personCount += 1
                                        self.people.append(BasicUser(id: property, name: property2, count: self.personCount))
                                    }
                                }
                                db.collection("users").document(Auth.auth().currentUser!.uid).getDocument { (document, error) in
                                    if let document = document, document.exists {
                                        
                                        let property = document.get("id") as! String
                                        let property2 = document.get("name") as! String
                                        var property3 = document.get("hasInteractedWith") as! [String]
                                        print(property)
                                        var property4 = document.get("hasInteractedWith2") as! [String]
                                        property3.append(self.matchedPerson.id)
                                        property4.append(self.chatRoom)
                                        
                                        
                                        db.collection("users").document(property).setData([ "hasInteractedWith": property3], merge: true)
                                        
                                        
                                        db.collection("users").document(property).setData([ "hasInteractedWith2": property4], merge: true)
                                        
                                        
                                        
                                        
                                        
                                        if property3.contains(self.userData.userID) {
                                            self.hasInteractedBefore = true
                                        }
                                        else {
                                            self.personCount += 1
                                            self.people.append(BasicUser(id: property, name: property2, count: self.personCount))
                                        }
                                    }
                                    self.hasFound = true
                                    
                                    self.hasAppeared = true
                                    print("appear2")
                                    
                                    
                                }
                            }
                    }
                }
                //ChatV2(matchedPerson: self.matchedPerson.name, chatRoom: self.chatRoom ,matchedPersonID: self.matchedPerson.id)
                
                if self.auth {
                    RegistrationView()
                    
                    
                }
                
                if self.hasFound {
                    
                    ChatV2(matchedPerson: self.matchedPerson.name, chatRoom: chatRoom, matchedPersonID: self.matchedPerson.id)
                }
                
                
            }
        }
    }
}
