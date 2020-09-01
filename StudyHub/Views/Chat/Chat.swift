//
//  Chat.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI
import Firebase

struct ChatV2: View {
    @State var matchedPerson = ""
    @State var chatRoom = ""
    @State var matchedPersonID = ""
    @State var chat = [ChatData]()
    @State var i = 0
    @State var total = -1
    @State var hasAppeared = false
    @State var hasMessage = false
    @State var message = "Message"
    @State var goBack = false
    @State var add = false
    @State var testing = true
    @EnvironmentObject var userData: UserData
    var body: some View {
        
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(.all)
                
                
                .onAppear() {
                    self.chat.removeAll()
                    
                    withAnimation() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.loadData()
                        }
                    }
            }
            
            VStack {
                
                
                Text(matchedPerson)
                    .font(.title)
                    .padding(.top, 22)
                Spacer()
            }
            VStack {
                ScrollView(.vertical) {
                    
                    if self.hasAppeared {
                        VStack {
                            
                            
                            
                            ForEach(chat, id: \.id) { chating in
                                Group {
                                    
                                    if !chating.isMe {
                                        ChatV2Cell2(name: chating.name, message: chating.message)
                                            .padding(.top, 62)
                                            .padding(.horizontal, 12)
                                    }
                                    if chating.isMe {
                                        
                                        ChatV2Cell(name: chating.name, message: chating.message)
                                            .padding(.top, 62)
                                            .padding(.horizontal, 12)
                                        
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
                Spacer()
                Divider()
                HStack {
                    
                    TextField("Message", text: $message)
                        .foregroundColor(.gray)
                        .frame(height: 50)
                        .onTapGesture {
                            self.message = ""
                    }
                    Spacer()
                    Ellipse()
                        .foregroundColor(Color(.systemBlue))
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            
                            var db: Firestore!
                            db = Firestore.firestore()
                            self.total = self.total + 1
                            let data = [ "name": self.userData.name,
                                         "message": self.message]
                            db.collection("chats").document(self.chatRoom).updateData([
                                "\(self.total)": data,
                                "total": self.total,
                                
                            ]) { err in
                                if let err = err {
                                    print("Error writing document: \(err)")
                                    db.collection("chats").document(self.chatRoom).setData([
                                        "\(self.total)": data,
                                        "total": self.total,
                                        
                                    ]) { err in
                                        if let err = err {
                                            print("Error writing document: \(err)")
                                        } else {
                                            print("Document successfully written!")
                                        }
                                    }
                                } else {
                                    print("Document successfully written!")
                                    db.collection("users").getDocuments() { (querySnapshot, err) in
                                        if let err = err {
                                            print("Error getting documents: \(err)")
                                        } else {
                                            for document in querySnapshot!.documents {
                                                print("\(document.documentID) => \(document.data())")
                                                let receiver = document.get("fcmToken") as! String
                                                let sender = PushNotificationSender()
                                                sender.sendPushNotification(to: receiver, title: self.userData.name, body: self.message, user: Auth.auth().currentUser!.uid)
                                            }
                                        }
                                    }
                                }
                            }
                            self.message = ""
                    }
                } .padding([.trailing, .leading], 12)
                    .padding(.bottom, 22)
            }
            
        }
    }
    func loadData() {
        var db: Firestore!
        db = Firestore.firestore()
        
        let docRef = db.collection("chats").document(self.chatRoom)
        
        docRef.addSnapshotListener { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                let total = document.get("total") as! Int
                self.total = total
                while self.i <= total {
                    
                    let property = document.get("\(self.i)") as! [String: String]
                    
                    print("hi" + " " + "\(property)")
                    
                    if property["name"]! == self.userData.name {
                        
                        self.chat.append(ChatData(id: "\(UUID())", name: property["name"]! , message: property["message"]!, isMe: true))
                        print("TRUE")
                    }
                    if property["name"]! != self.userData.name {
                        self.chat.append(ChatData(id: "\(UUID())", name: property["name"]! , message: property["message"]!, isMe: false))
                        print("FALSE")
                        
                    }
                    
                    self.i = self.i + 1
                }
                
                print("Document data: \(dataDescription)")
                
            } else {
                print("Document does not exist")
            }
        }
        print(matchedPerson)
        
        self.userData.interactedPeople.append(self.matchedPersonID)
        self.userData.chats.append(self.chatRoom)
        print("hasInteractedWith")
        self.hasAppeared = true
        if testing {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            var db: Firestore!
            db = Firestore.firestore()
            self.total = self.total + 1
            let data = [ "name": self.userData.name,
                         "message": "Test"]
            db.collection("chats").document(self.chatRoom).updateData([
                "\(self.total)": data,
                "total": self.total,
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                    db.collection("chats").document(self.chatRoom).setData([
                        "\(self.total)": data,
                        "total": self.total,
                        
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                } else {
                    print("Document successfully written!")
                    db.collection("users").getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                print("\(document.documentID) => \(document.data())")
                                let receiver = document.get("fcmToken") as! String
                                let sender = PushNotificationSender()
                                sender.sendPushNotification(to: receiver, title: self.userData.name, body: self.message, user: Auth.auth().currentUser!.uid)
                            }
                        }
                    }
                    }
                }
            }
        }
    }
}
