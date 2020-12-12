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
    @State var group = Groups(id: "", groupID: "", groupName: "", members: [""], interests: [nil])
    @Environment(\.presentationMode) var presentationMode
    @Binding var chatRoomID: String
    @State var image = UIImage()
    @State var name: String = ""
    @Binding var chat: Bool
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
                .onAppear() {
                    //viewRouter.showTabBar = false
                }
           
                VStack {
                    //Testing UI with some messages
                    HStack {
                        ProfilePicture(pictureSize: 50, image: image)
                    Text(name)
                        .font(.custom("Montserrat", size: 15))
                        .padding()
                        .foregroundColor(.black)
                        Spacer()
                    } .padding()
//                    ReverseScrollView(scrollOffset: CGFloat(self.scrollOffset), currentOffset: CGFloat(self.currentOffset)){
//                        VStack {
//                    ForEach(self.messages, id: \.self){ message in
//                        MessageCellView(message)
//
//                    }
//                        }
//                    }
                    ScrollView(.vertical, showsIndicators: false) {
                        ScrollViewReader { scrollView in
                            LazyVStack {
                                ForEach(self.messages) { message in
                                    MessageCellView(message)
                                        .id(message.id)
                                }
                            }
                            .onChange(of: messages, perform: { value in
                                withAnimation(.linear(duration: 0.1)) {
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
                        
                       // Spacer()
                    }
                    .frame(maxWidth: .infinity)
                   // .frame(height: 200)
                    
                    // .offset(x: 0, y: 100)
                    
                }
                
               
            }
        
        .onAppear{
            self.loadData()
        }
      

    }
    func saveMessage(outgoingMessage:MessageData){
        let db = Firestore.firestore()
        let ref = db.collection("message/\(chatRoomID)/messages/").document(UUID().uuidString)
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
