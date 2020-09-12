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

struct ChatView: View {
    @EnvironmentObject var userData:UserData
    @ObservedObject var chatDataInfo = ChatDataInfo.sharedChatData
    @State var messageField = ""
    @State var scrollOffset = 0
    @State var currentOffset = 0
    
    var body: some View {
        ReverseScrollView(scrollOffset: CGFloat(self.scrollOffset), currentOffset: CGFloat(self.currentOffset)){
            VStack {
                //Testing UI with some messages
                ChatCell(message: "Hi there, how are you doing?")
                ChatCellSelf(message: "I am fine.")
                
                Spacer()
                
                //The bottom function bar that displays field, send button, and some other functions such as mic and cancel
                VStack{
                    HStack {
                        MessageButtons(imageName: "xmark")
                        MessageButtons(imageName: "mic.fill")
                        MessageFieldView(messageField: self.$messageField)
                    }
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
        .onAppear{
                
        }
    }
 
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}



struct MessageFieldView: View {
    @Binding var messageField:String
    var body: some View {
        TextField("Enter message", text: self.$messageField)
            .font(.custom("Montserrat", size: 15))
            .padding()
            .frame(width: 250, height: 40)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                HStack {
                    Spacer()
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.gray.opacity(1))
                        .padding(.trailing, 15)
                }
        )
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
