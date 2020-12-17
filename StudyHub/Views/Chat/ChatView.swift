//
//  ChatView.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Alamofire
//!!!You do not use OnAppear method with this view, this view
//is created at the same time as AddChat View!!!
struct ChatView: View {
    @EnvironmentObject var userData:UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @Environment(\.presentationMode) var presentationMode
    
    @State var messageField = ""
    @State var messages = [MessageData]()
    
    var group:Groups
    //@State var image:Image
    @Binding var chat: Bool
    @State var ARChat = false
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            
            VStack {
                //Testing UI with some messages
                HStack {
                    
                    ProfilePicture(pictureSize: 50, image: Image("demoprofile"))
                    Text(group.groupName)
                        .font(.custom("Montserrat", size: 15))
                        .padding()
                        .foregroundColor(.black)
                    Spacer()
                    
                    Button(action: {
                        let request = AF.request("https://studyhub1.herokuapp.com/access_token?channel=\(group.groupID)&uid=0")
                        
                        request.responseJSON { (response) in
                            print(response)
                            guard let tokenDict = response.value as! [String : Any]? else { return }
                            let token = tokenDict["token"] as! String
                            
                            AgoraARKit.agoraToken = token
                            AgoraARKit.channelname = group.groupID
                            if AgoraARKit.agoraToken != "" {
                                ARChat.toggle()
                            }
                        }
                        
                    }) {
                        Image(systemName: "phone")
                            .foregroundColor(Color("Secondary"))
                    }
                } .padding()
                
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(self.messages) { message in
                                MessageCellView(message)
                                    .id(message.id)
                            }
                        }
                        .onChange(of: messages, perform: { value in
                            withAnimation(Animation.linear.speed(5)) {
                                scrollView.scrollTo(messages.last?.id, anchor: .bottom)
                            }
                        })
                    }
                }
                Spacer()
                
                //The bottom function bar that displays field, send button, and some other functions such as mic and cancel
                VStack{
                    Divider()
                    HStack {
                        
                        MessageButtons(imageName: "xmark")
                            .onTapGesture {
                                
                                
                                presentationMode.wrappedValue.dismiss()
                                chat = false
                            }
                        MessageButtons(imageName: "mic.fill")
                        Spacer()
                        TextField("Enter message", text: self.$messageField)
                            .font(.custom("Montserrat", size: 15))
                            .padding()
                            .frame(height: 40)
                            .frame(maxWidth:.infinity)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(Color.gray.opacity(1))
                                .onTapGesture{
                                    if self.messageField != ""{
                                        let newMessage =                     MessageData(messageText: self.messageField, sentBy: self.userData.userID, sentTime: Date())
                                        self.messageField = ""
                                        self.saveMessage(outgoingMessage: newMessage)
                                    }

                                }
                            
                        
                    } .padding()
                    
                }
                .frame(maxWidth: .infinity)
                
                
            }
            
            if ARChat {
                VStack {
                    HStack {
                        Button(action: {
                            
                            
                        }) {
                            Image(systemName: "xmark")
                                .foregroundColor(Color("Secondary"))
                        }
                        Spacer()
                    }
                    Spacer()
                } .padding()
                ARVideoChatView(channelName: group.groupID)
            }
        }
        .onAppear{
            self.loadData()
            self.addRecentRecord()
            
        }
        
        
        
        
        
    }
    func saveMessage(outgoingMessage:MessageData){
        let db = Firestore.firestore()
        let ref = db.collection("message/\(group.groupID)/messages/").document(UUID().uuidString)
        do{
            try ref.setData(from: outgoingMessage)
        }
        catch{
            print("Error saving data, \(error)")
        }
    }
    
    
    
    
    
    func addRecentRecord(){
        let db = Firestore.firestore()
        
        let docRef = db.collection("users").document(userData.userID)
        docRef.getDocument{document, error in
            let result = Result {
                try document?.data(as: User.self)
            }
            switch result {
            case .success(let user):
                if let user = user {
                    var recentGroups = user.recentGroups ?? []
                    if recentGroups.count < 4{
                        docRef.updateData(
                            ["recentGroups":FieldValue.arrayUnion([group.groupID])]
                        )
                    }
                    else{
                        recentGroups.removeFirst(1)
                        recentGroups.append(group.groupID)
                        docRef.updateData(
                            ["recentGroups":recentGroups]
                        )
                    }
                } else {
                    
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding city: \(error)")
            }
        }
        
        
    }
    func loadData(){
        let db = Firestore.firestore()
        
        let docRef = db.collection("message/\(group.groupID)/messages").order(by: "sentTime").limit(to: 50)
        docRef.addSnapshotListener{ (querySnapshot, error) in
            var messageArray:[MessageData] = []
            
            if let document = querySnapshot, !document.isEmpty{
                
                
                for document in document.documents{
                    
                    let result = Result {
                        try document.data(as: MessageData.self)
                    }
                    switch result {
                    case .success(let messageData):
                        if let messageData = messageData {
                            messageArray.append(self.parseMessageData(messageData: messageData))
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                }
            }
            print(messageArray)
            self.messages = messageArray
            
        }
    }
    func parseMessageData(messageData:MessageData) -> MessageData{
        var messageData = messageData
        if messageData.sentBy == userData.userID{
            messageData.sentBySelf = true
        }
        else{
            messageData.sentBySelf = false
        }
        
        return messageData
        
    }
    
    func MessageCellView(_ message: MessageData) -> AnyView {
        if message.sentBySelf! {
            return AnyView(ChatCellSelf(message: message.messageText))
        } else {
            return AnyView(ChatCell(message: message.messageText))
        }
    }
    
    
}





struct MessageButtons: View {
    var imageName:String
    var body: some View {
        Image(systemName: imageName)
            .foregroundColor(Color.gray.opacity(1))
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 2))
                    .foregroundColor(Color.gray.opacity(0.3))
                    .background(Color.gray.opacity(0.2))
            )
            .clipShape(Circle())
    }
}
