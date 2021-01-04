//
//  ChatView.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.

import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Alamofire
import AgoraRtcKit
//!!!You do not use OnAppear method with this view, this view
//is created at the same time as AddChat View!!!
struct ChatView: View {
    @EnvironmentObject var userData:UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @Environment(\.presentationMode) var presentationMode
    //@State var nameAndProfiles:[NameAndProfileModel] = []
    @State var messageField = ""
    @State var messages = [MessageData]()
    @State var members = [User]()
    @State var group: Groups
    //@State var image:Image
    @State var ARChat = false
    @State var test = true
    @State var membersList = false
    @State var person = User(id: UUID(), firebaseID: "", name: "", email: "", profileImageURL: URL(string: ""), interests: [UserInterestTypes](), groups: [String](), isMentor: false, recentGroups: [String](), recentPeople: [String](), studyHours: [Double](), studyDate: [String](), all: 0.0, month: 0.0, day: 0.0, description: "", isAvailable: false)
    @State var token = ""
    @State var showFull = false
    @State var keyboardHeight:CGFloat = CGFloat.zero
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
            VStack {
                //Testing UI with some messages
                
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(self.messages, id:\.self) { message in
                                MessageCellView(message)
                                    .id(message.id)
                                    
                            }
                        } .transition(.opacity)
                        .animation(.easeInOut(duration: 0.7))
                        .drawingGroup()
                        .padding(.top,5)
                        .onChange(of: messages, perform: { value in
                            
                            withAnimation() {
                                scrollView.scrollTo(messages.last, anchor: .bottom)
                            }
                        })
                    }
                }
                .disabled(membersList ? true : false)
                
                Spacer()
                
                Divider()
                HStack {
                    
                    MessageButtons(imageName: "xmark")
                        .onTapGesture {
                            
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                  //  MessageButtons(imageName: "mic.fill")
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
                                let newMessage = MessageData(messageText: self.messageField, sentBy: self.userData.userID, sentTime: Date())
                                for member in members {
                                let sender = PushNotificationSender()
                                    if member.fcmToken != nil {
                                    sender.sendPushNotification(to: member.fcmToken!, title: userData.name, body: self.messageField, user: userData.userID)
                            }
                                }
                                self.messageField = ""
                                self.saveMessage(outgoingMessage: newMessage)
                                
                            }
                            
                        }
                    
                    
                }
                .onReceive(Publishers.keyboardHeight){height in
                    keyboardHeight=height
                }
                .padding(.horizontal)
                .padding(.top)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity)
                
                
            }
            .blur(radius: membersList ? 8 : 0)
            .animation(.easeInOut)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Text(group.groupName)
                            .font(.custom("Montserrat-Bold", size: 18))
                            .padding()
                            .foregroundColor(Color("Text"))
                        
                    }
                }
                ToolbarItem(placement:.navigation){
                    HStack{
                        if test {
                            Button(action: {
                                let request = AF.request("https://studyhub1.herokuapp.com/access_token?channel=\(group.groupID)&uid=0")
                                
                                request.responseJSON { (response) in
                                    print(response)
                                    guard let tokenDict = response.value as! [String : Any]? else { return }
                                    let token = tokenDict["token"] as! String
                                    
                                    self.token = token
                                    
                                    if token != "" {
                                        ARChat.toggle()
                                    }
                                }
                                
                            }) {
                                Image(systemName: "phone")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("Secondary"))
                                
                            }
                            
                        }
                        Button(action: {membersList=true}){
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color("Secondary"))


                        }
                   
                    }
              
                }
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
                    VoiceChat(agoraKit: AgoraRtcEngineKit(), token: token, name: group.groupID, vc: $ARChat, group: group)
                }

            BottomCardSubview(displayView: AnyView(MemberListSubview(members: $members, memberList: $membersList, showFull: $showFull, group: $group, person: $person, messages: $messages)), showFull: $showFull, showCard: $membersList)
            
            }

            .onAppear{
                
                self.loadData()
                self.addRecentRecord()
                
                self.viewRouter.showTabBar = false

                self.loadMembers(){ userData in
                    //Get completion handler data results from loadData function and set it as the recentPeople local variable
                    self.members = userData ?? []
                    // getProfileImage()
                    
                }
            }
            .onDisappear{
                self.viewRouter.showTabBar = true
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
        
        //    func getProfileImage(){
        //        if nameAndProfiles == []{
        //            for member in members{
        //                let metadata = StorageMetadata()
        //                metadata.contentType = "image/jpeg"
        //                let storage = Storage.storage().reference().child("User_Profile/\(member)")
        //                storage.downloadURL{url, error in
        //                    if let error = error{
        //                        print("Error downloading image, \(error)")
        //                    }
        //                    let model = NameAndProfileModel(name: member.name, imageURL: url ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/study-hub-7540b.appspot.com/o/User_Profile%2F632803C1-F7B2-44C0-86A6-C589F17DEE97?alt=media&token=18198a24-b65e-4209-8c77-1f78ac6e6925")!)
        //                    nameAndProfiles.append(model)
        //                }
        //            }
        //        }
        //
        //
        //    }
        //
        
        
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
        
        
        func loadMembers(performAction: @escaping ([User]?) -> Void) {
            let db = Firestore.firestore()
            let docRef = db.collection("users").whereField("groups", arrayContains: group.groupID)
            var groupList:[User] = []
            //Get every single document under collection users
            
            docRef.getDocuments{ (querySnapshot, error) in
                if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
                    for document in querySnapshot.documents{
                        let result = Result {
                            try document.data(as: User.self)
                        }
                        switch result {
                        case .success(let user):
                            if var user = user {
                                
                                groupList.append(user)
                                
                            } else {
                                
                                print("Document does not exist")
                            }
                        case .failure(let error):
                            print("Error decoding user: \(error)")
                        }
                        
                        
                    }
                }
                else{
                    performAction(nil)
                }
                performAction(groupList)
            }
            
            
        }
        func loadData(){
            let db = Firestore.firestore()
            
            let docRef = db.collection("message/\(group.groupID)/messages").order(by: "sentTime")
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
                return AnyView(ChatCell(name: message.sentBy, message: message.messageText))
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
