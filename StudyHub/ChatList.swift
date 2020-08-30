//
//  ChatList.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
struct ChatList: View {
    @State var people = [ChattedWith]()
    @EnvironmentObject var userData: UserData
    @State var hasData = false
    @State var tapped = false
    @State var add = false
    @State var auth = false
    @State var personCount = -1
    @State var chatRoom = [""]
    @State var userIDs = [""]
    @State private var activeSheet: ActiveSheet = .first
    enum ActiveSheet {
        case first, second
    }
    var body: some View {
        ZStack {
            Color(.white)
                .onAppear() {
                    
                    self.personCount = -1
                    
                    self.hasData = false
                    self.people.removeAll()
                    self.chatRoom.removeAll()
                    print(Auth.auth().currentUser?.uid)
                    if Auth.auth().currentUser?.uid == nil {
                        self.auth = true
                    } else {
                        
                        self.loadData()
                    }
            }
            
            
            
            
            if self.auth {
                Color(.white)
                RegistrationView()
            }
            if Auth.auth().currentUser?.uid != nil {
                if hasData {
                    Color(.white)
                    List {
                        ForEach(people, id: \.id) { person in
                            
                            Group {
                                
                                HStack {
                                    Text(person.name)
                                        .padding(.top, 42)
                                        .onTapGesture {
                                            self.personCount = person.count
                                            self.activeSheet = .second
                                            self.tapped.toggle()
                                            
                                    }
                                    Spacer()
                                }
                                
                                
                            }
                            
                        }
                        
                    }
                    .sheet(isPresented: $tapped) {
                        if self.activeSheet == .first {
                            AddChat()
                                .environmentObject(UserData.shared)
                        }
                        else if self.activeSheet == .second {
                            ChatV2(matchedPerson: self.people[  self.personCount].name,chatRoom: self.chatRoom[self.personCount])
                                .environmentObject(UserData.shared)
                        }
                    }
                    VStack {
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                self.activeSheet = .first
                                self.tapped.toggle()
                            }) {
                                
                                ZStack {
                                    Circle()
                                        .foregroundColor(.black)
                                    Image("add")
                                        .resizable()
                                        .renderingMode(.original)
                                        .frame(width: 20, height: 20, alignment: .center)
                                        .scaledToFit()
                                }  .frame(width: 50, height: 50, alignment: .center)
                            }
                            
                        }
                        Spacer()
                    } .padding(12)
                    
                    
                }
            }
            
            
        }
    }
    func loadData() {
        var db: Firestore!
        db = Firestore.firestore()
        print(1)
        db.collection("users").document(Auth.auth().currentUser!.uid).addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                
                
                let name = document.get("name") as! String
                let id = document.get("id") as! String
                let hasInteractedWith = document.get("interactedPeople") as! [String]
                print(hasInteractedWith)
                self.chatRoom = document.get("interactedChatRooms") as! [String]
                self.userIDs = hasInteractedWith
                for interacted in hasInteractedWith {
                    
                    db.collection("users").document(interacted).getDocument { (document, error) in
                        if let document = document, document.exists {
                            
                            let name = document.get("name") as! String
                            let id = document.get("id") as! String
                            print(id)
                            
                            print(self.chatRoom)
                            if !self.tapped {
                                self.personCount += 1
                                self.people.append(ChattedWith(id: id, name: name, count: self.personCount, chatRoom: self.chatRoom[self.personCount]))
                                
                                
                                print("chatroom ids =   \(self.chatRoom)")
                                print("user ids =   \(self.userIDs)")
                                
                            }
                            // for person in self.people {
                            
                            //  if person.id == Auth.auth().currentUser!.uid {
                            
                            //  print("Remove")
                            // self.people.remove(at: self.num)
                            // self.num -= 1
                            //  self.personCount -= 1
                            // }
                            //    print("Add")
                            
                            self.hasData = true
                        }
                        
                    }
                    print(self.personCount)
                    //   print(self.people[self.personCount].chatRoom)
                    
                }
            }
        }
        //   print(self.index)
    }
}



