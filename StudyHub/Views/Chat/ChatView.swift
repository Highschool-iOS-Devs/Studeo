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

//!!!You do not use OnAppear method with this view, this view
//is created at the same time as AddChat View!!!
struct ChatView: View {
    @EnvironmentObject var userData:UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @State var messageField = ""
    @State var scrollOffset = 0
    @State var currentOffset = 0
    @State var messages = [MessageData]()
    @State var group = Groups(id: "", groupName: "", groupID: "", createdBy: "", members: [""], interests: [""])
    var chatRoomID:String
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            ReverseScrollView(scrollOffset: CGFloat(self.scrollOffset), currentOffset: CGFloat(self.currentOffset)){
                VStack {
                    //Testing UI with some messages
                    Text(group.groupID)
                        .font(.custom("Montserrat", size: 15))
                        .padding()
                        .foregroundColor(.black)
                    ForEach(self.messages, id: \.self){ message in
                        MessageCellView(message)
                       
                    }
                    Spacer()
                    
                    //The bottom function bar that displays field, send button, and some other functions such as mic and cancel
                    VStack{
                        HStack {
                            MessageButtons(imageName: "xmark")
                                .onTapGesture {
                                    self.viewRouter.showChatView = false
                            }
                            MessageButtons(imageName: "mic.fill")
                            Spacer()
                            TextField("Enter message", text: self.$messageField)
                                .font(.custom("Montserrat", size: 15))
                                .padding()
                                .frame(height: 40)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                .overlay(
                                    HStack {
                                        Spacer()
                                        Image(systemName: "paperplane.fill")
                                            .foregroundColor(Color.gray.opacity(1))
                                            .padding(.trailing, 15)
                                            .onTapGesture{
                                                if self.messageField != ""{
                                                    let newMessage =                     MessageData(messageText: self.messageField, sentBy: self.userData.userID, sentTime: Date())

                                                    self.saveMessage(outgoingMessage: newMessage)
                                                }
                                            }
                                           
                                    }
                            )
                        } .padding()
                        .padding(.top, 30)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                    .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(Color.gray.opacity(0.3))
                    
                    )
                     .offset(x: 0, y: 100)
                    
                }
                
               
            }
        }
        .onAppear{
            self.loadData()
        }
      

    }
    func saveMessage(outgoingMessage:MessageData){
        let db = Firestore.firestore()
        let ref = db.collection("message/\(self.chatRoomID)/messages/").document(UUID().uuidString)
      do{
        try ref.setData(from: outgoingMessage)
      }
      catch{
          print("Error saving data, \(error)")
      }
    }
    
    func loadData(){
        let db = Firestore.firestore()
        
        let docRef = db.collection("message/\(chatRoomID)/messages").order(by: "sentTime").limit(to: 50)
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
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(chatRoomID: "")
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

//    @State var matchedPerson = ""
//    @State var chatRoom = ""
//    @State var matchedPersonID = ""
//    @State var chat = [ChatData]()
//    @State var i = 0
//    @State var total = -1
//    @State var hasAppeared = false
//    @State var hasMessage = false
//    @State var message = "Message"
//    @State var goBack = false
//    @State var add = false
//    @State var testing = true
//    @State var testName = ""
//    @State var currentOffset = 0
//    @State var scrollOffset = 0
//    @State var addChat = false
//
//    @EnvironmentObject var userData: UserData
//    var body: some View {
//
//        ZStack {
//            Color(.white)
//                .edgesIgnoringSafeArea(.all)
//
//
//                .onAppear() {
//                    // self.chat.removeAll()
//                    self.i = 0
//                    self.total = -1
//                    withAnimation() {
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                            self.loadData()
//                        }
//                    }
//            }
//
//            VStack {
//
//
//                Text(matchedPerson)
//                    .font(.title)
//                    .padding(.top, 22)
//                Spacer()
//            }
//            VStack {
//                if self.hasAppeared {
//                    ReverseScrollView(scrollOffset: CGFloat(self.scrollOffset), currentOffset: CGFloat(self.currentOffset)) {
//
//
//                        VStack {
//
//
//
//                            ForEach(self.chat, id: \.id) { chating in
//                                Group {
//
//                                    if !chating.isMe {
//                                        ChatV2Cell2(name: chating.name, message: chating.message)
//                                            .padding(.top, 62)
//                                            .padding(.horizontal, 12)
//                                    }
//                                    if chating.isMe {
//
//                                        ChatV2Cell(name: chating.name, message: chating.message)
//                                            .padding(.top, 62)
//                                            .padding(.horizontal, 12)
//
//                                    }
//
//
//                                }
//                            }
//
//                        }
//                    }
//
//                }
//
//                Spacer()
//                Divider()
//                HStack {
//
//                    TextField("Message", text: $message)
//                        .foregroundColor(.gray)
//                        .frame(height: 50)
//                        .onTapGesture {
//                            self.message = ""
//                    }
//                    Spacer()
//                    Ellipse()
//                        .foregroundColor(Color(.systemBlue))
//                        .frame(width: 50, height: 50)
//                        .onTapGesture {
//
//                    }
//                } .padding([.trailing, .leading], 12)
//                    .padding(.bottom, 22)
//            }
//
//        }
//    }
//    func loadData() {
//
//    }
//}
