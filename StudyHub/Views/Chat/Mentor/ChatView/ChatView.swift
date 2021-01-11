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
    @State var memeberSent = [MessageData]()
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
    @Binding var show: Bool
    @State var showLoadingAnimation = false
    @State var showImagePicker = false
    @State private var image : UIImage? = nil
    @State var viewImage = false
    @State var id = ""
    @State var toggleReaction = false
    @State var message = MessageData(id: "", messageText: "", sentBy: "", sentByName: "", sentTime: Date(), sentBySelf: false, assetID: "", reactions: [String]())
    @State var reactions = ["love", "thumbsup", "celebrate", "laugh"]
    @State private var lastMessageID = ""
    @State var reaction = "love"
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
                .onAppear() {
                    //viewRouter.showTabBar = false
                    messages.removeAll()
                    memeberSent.removeAll()
                }
            VStack {
                //Testing UI with some messages
                
                ScrollView(.vertical, showsIndicators: false) {
                    ScrollViewReader { scrollView in
                        LazyVStack {
                            ForEach(self.messages) { message in
                                VStack {
                                    HStack {
                                        if message.sentBySelf ?? false {
                                            Spacer()
                                        }
                                    
                                    if message.assetID != "" {
                                        assetMessage(assetID: message.assetID)
                                            .frame(width: 150, height: 150)
                                            .onTapGesture() {
                                                id = message.assetID
                                                viewImage = true
                                            }
                                    }
                                    if !message.sentBySelf! {
                                        Spacer()
                                    }
                                    }
                                MessageCellView(message)
                                    .id(message.id)
                                    .frame(minWidth: 100, minHeight: 50)
                                    .onLongPressGesture {
                                       // toggleReaction = true
                                        self.message = message
                                    }
                                    HStack {
                                        if message.sentBySelf ?? false {
                                            Spacer()
                                        }
                                    
                                        
                                        if !message.sentBySelf! {
                                            Spacer()
                                        }
                                        if !message.reactions.isEmpty {
                                            HStack {
                                            ForEach(message.reactions, id:\.self) { reaction in
                                                Text(reaction == "love" ? "❤️" : "")
                                                
                                                Text(reaction == "thumbsup" ? "👍" : "")
                                                
                                                Text(reaction == "laugh" ? "🤣" : "")
                                                
                                                Text(reaction == "celebrate" ? "🎉" : "")
                                               
                                            }
                                            }
                                        }
                                    } .padding(.horizontal)
                                   
                                }
                            }
                        } .transition(.opacity)
                        .animation(.easeInOut(duration: 0.7))
                        .drawingGroup()
                        .padding(.top,5)
                        .onChange(of: messages, perform: { messages in
                            guard let lastMessage = messages.last else { return }
                            if let id = lastMessage.id {
                                withAnimation(.easeInOut(duration: 1.5)) {
                                self.lastMessageID = id
                            }
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation(.easeInOut(duration: 1.5)) {
                                scrollView.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                            }
                        })
                        .onReceive(Publishers.keyboardHeight){height in
                            guard !lastMessageID.isEmpty else { return }

                            withAnimation(.easeInOut(duration: 1.5)) {
                                scrollView.scrollTo(self.lastMessageID, anchor: .bottom)
                            }
                        }
                    }
                }
                .disabled(membersList ? true : false)
                
                Spacer()
                
                Divider()
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        
                        .id(UUID())
                }
                HStack {
                    
                    MessageButtons(imageName: "xmark")
                        .onTapGesture {
                            show = false
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                    MessageButtons(imageName: "camera.fill")
                        .onTapGesture {
                           
                            showImagePicker = true
                        }
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
                            var id = ""
                            if image != nil {
                                id = UUID().uuidString
                                let metadata = StorageMetadata()
                                metadata.contentType = "image/jpeg"
                             let storage = Storage.storage().reference().child("Message_Assets/\(id)")
                             if let image = image {
                             
                                 storage.putData(image.jpegData(compressionQuality: 100)!, metadata: metadata) { meta, error in
                                    if let error = error {
                                        print(error)
                                        return
                                    }

                                    

                                }
                             }
                            }
                            if self.messageField != ""{
                                let newMessage = MessageData(messageText: self.messageField, sentBy: self.userData.userID, sentByName: self.userData.name, sentTime: Date(), assetID: id != "" ? id : "", reactions: [String]())
                                for member in members {
                                let sender = PushNotificationSender()
                                    if member.fcmToken != nil {
                                    sender.sendPushNotification(to: member.fcmToken!, title: userData.name, body: self.messageField, user: userData.userID)
                            }
                                }
                                self.messageField = ""
                                self.saveMessage(outgoingMessage: newMessage)
                                
                            }
                           
                            image = nil
                        }
                    
                    
                }
                .sheet(isPresented: self.$showImagePicker){
                    ImagePicker(isShown: self.$showImagePicker, image: self.$image, userID: $userData.userID)
                        .environmentObject(userData)
                       
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
                                showLoadingAnimation = true
                                let request = AF.request("https://studyhub1.herokuapp.com/access_token?channel=\(group.groupID)&uid=0")
                                
                                request.responseJSON { (response) in
                                    print(response)
                                    guard let tokenDict = response.value as! [String : Any]? else { return }
                                    let token = tokenDict["token"] as! String
                                    
                                    self.token = token
                                    
                                    if token != "" {
                                        ARChat = true
                                    }
                                }
                                
                            }) {
                                Image(systemName: "phone")
                                    .font(.system(size: 25))
                                    .foregroundColor(Color("Primary"))
                                
                            }
                            
                        }
                        Button(action: {membersList=true}){
                            Image(systemName: "ellipsis.circle.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color("Primary"))


                        }
                   
                    }
              
                }
            } .onTapGesture() {
                toggleReaction = false
            }
            if toggleReaction {
                HStack { //.font(.custom("Montserrat-regular", size: 14)).foregroundColor(Color("Text"))
                    Picker(selection: $message.reactions, label: HStack{
                            Text("Reaction: ")
                            }) {
                        ForEach(reactions, id: \.self) { (reaction) in
                            if reaction == "love" {
                                Text("❤️")
                            } else
                            if reaction == "thumbsup" {
                                Text("👍")
                            } else
                            if reaction == "laugh" {
                                Text("🤣")
                            } else
                            if reaction == "celebrate" {
                                Text("🎉")
                            }
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .foregroundColor(Color("Text"))
                    .font(.custom("Montserrat-regular", size: 14))
                    
                }
                .padding(.trailing, 10)
            }
            if viewImage {
                FullImageView(id: $id, viewImage: $viewImage)
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
                    VoiceChat(agoraKit: AgoraRtcEngineKit(), token: token, name: group.groupID, vc: $ARChat, group: group, loadingAnimation: $showLoadingAnimation)
                }
        
            BottomCardSubview(displayView: AnyView(MemberListSubview(members: $members, memberList: $membersList, showFull: $showFull, group: $group, person: $person, messages: $messages)), showFull: $showFull, showCard: $membersList)
            
            if showLoadingAnimation{
                VStack{
                    LottieUIView()
                        .animation(.easeInOut)
                    Text("Joining Voice Chat...")
                        .font(.custom("Montserrat-SemiBold", size: 25))
                        .offset(y: -40)
                        .foregroundColor(Color("Text"))
                }
                .frame(width: 300, height: 400)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 10, y: 10)
                .animation(.easeInOut)
                
            }
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
                return AnyView(ChatCellSelf(message: message, group: group))
            } else {
                return AnyView(ChatCell(name: message.sentBy, message: message, group: group))
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
struct assetMessage: View {
    var assetID: String
    @State var image = UIImage()
    var body: some View {

        ZStack {
            Color.clear
                .onAppear() {
                    getProfileImage()
                }
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                
        }
    }
    func getProfileImage() {
      

        // Create a storage reference from our storage service
        
            
      
        let storage = Storage.storage().reference().child("Message_Assets/\(assetID)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storage.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
           print(error)
          } else {
            // Data for "images/island.jpg" is returned
            withAnimation(.easeInOut) {
            image = UIImage(data: data!)!
                
            }
          }
        }
    }
}
