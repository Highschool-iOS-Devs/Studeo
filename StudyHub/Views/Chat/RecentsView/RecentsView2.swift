//
//  RecentsView2.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecentsView2: View {
//    @State var allGroups: [Groups] = []
//    @State var recentPeople: [User] = []
//    @State var recentGroups: [Groups] = []
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter: ViewRouter
    @StateObject var groupModel = ChatViewModel()
    @State var add: Bool = false
    @State var settings: Bool = false
    @State var showTimer = false
    @Binding var myMentors:[Groups]
    @Binding var timerLog: [TimerLog]
    @Binding var devChats:[Groups]
    
@State var show = false
    
    @State var gridLayout: [GridItem] = [ ]
    @State private var orientation = UIDeviceOrientation.unknown
    var body: some View {
        ZStack {
            Color("Background").edgesIgnoringSafeArea(.all)
        NavigationView{
           
                VStack(spacing: 0) {
                    ScrollView {
                       
                    LazyVGrid(columns: gridLayout, spacing: 30) {
                     
                            RecentChatTextRow(add: $add)
                                
                        if UIDevice.current.userInterfaceIdiom == .phone {
                            Spacer()
                        }
                            if groupModel.allGroups == [] {
                                
                                Text("You are not in any study group yet,\n\nUse the add button to pair. 🙌").font(Font.custom("Montserrat-Bold", size: 24, relativeTo: .headline)).foregroundColor(Color(#colorLiteral(red: 0.27, green: 0.89, blue: 0.98, alpha: 1)))
                                .multilineTextAlignment(.center)
                                    .frame(width: 250)
                                    .frame(height:425)
                            }
                            else{
                               
                                    if !groupModel.recentGroups.isEmpty {
                                        VStack {
                                            ForEach($groupModel.recentGroups) { $group in//, id: \.groupID){ group in
#warning("maybe the issue is here")
                                            
                                        NavigationLink(
                                           
                                            destination:ChatView(userData: userData, viewRouter: viewRouter, group: $group, show: $show)
                                                        
                                            ){
                                            
                                            RecentGroupRowSubview(group: group, profilePicture: Image("demoprofile"), userData: userData)
                                                .padding(.horizontal, 20)
                                                .environmentObject(UserData.shared)
                                            
                                        
                                            
                                        
                                    }
                                    }
                                    Spacer()
                                }
                               
                               
                                    }
                             
                           
                            if !groupModel.allGroups.isEmpty {
                                if !orientation.isPortrait {
                                
                               
                                    ForEach($groupModel.allGroups) { $group in//, id: \.groupID){group in
                                        NavigationLink(destination: ChatView(userData: userData, viewRouter: viewRouter, group: $group, show: $show)
                                                        ){
                                           
                                            RecentChatGroupSubview(group: group)
                                                .environmentObject(UserData.shared)
                                        }
                                    
                                    }
                                } else {
                                    AllGroupTextRow()
                                LazyVGrid(columns: gridItemLayout, spacing: 40){
                                    ForEach($groupModel.allGroups) { $group in//, id: \.groupID){group in
                                        NavigationLink(destination: ChatView(userData: userData, viewRouter: viewRouter, group: $group, show: $show)
                                                        ){
                                           
                                            RecentChatGroupSubview(group: group)
                                                .environmentObject(UserData.shared)
                                        }
                                    
                                    }
                                }
                                }
                            
                            }
                            if !myMentors.isEmpty {
                            HStack{
                                
                                    Text("Mentors").font(Font.custom("Montserrat-Bold", size: 24, relativeTo: .headline)).foregroundColor(Color("Primary"))
                                Spacer()
                                
                            } .padding()
                          
                            LazyVGrid(columns: gridItemLayout, spacing: 40) {
                                ForEach(myMentors.indices) { i in//, id: \.groupID){ i in
                                    NavigationLink(
                                        destination:ChatView(userData: userData, viewRouter: viewRouter, group: $myMentors[i], show: $show)
                                                    
                                           
                                        ){
                                    RecentChatGroupSubview(group: myMentors[i])
                                       
                                        
                                }
                                }
                            }
                            }
                            if !devChats.isEmpty {
                            HStack{
                                
                                    Text("Dev Chats").font(Font.custom("Montserrat-Bold", size: 24, relativeTo: .headline)).foregroundColor(Color("Primary"))
                                Spacer()
                                
                            } .padding()
                          
                            LazyVGrid(columns: gridItemLayout, spacing: 40) {
                                ForEach(devChats.indices) { i in//, id: \.groupID){ i in
                                    NavigationLink(
                                        destination:ChatView(userData: userData, viewRouter: viewRouter, group: $devChats[i], show: $show)
                                                    
                                           
                                        ){
                                    RecentChatGroupSubview(group:devChats[i])
                                       
                                        
                                }
                                }
                            }
                            }
                            Spacer(minLength: 200)
                        }
                      
                    
                    }
                   
                    .background(Color("Background"))
                    .cornerRadius(20)
                   

                    if showTimer {
                        VStack {
                            TimerView(showingView: $showTimer, timerLog: $timerLog)
                                .padding(.top, 110)
                                .transition(.move(edge: .bottom))
                                .onAppear {
                                    self.viewRouter.showTabBar = false
                                }
                                .onDisappear {
                                    self.viewRouter.showTabBar = true
                            }
                        }
                    }
            }
                }
            
            .fullScreenCover(isPresented: $add){
               // PairingView(settings: $settings, add: $add, myGroups: $groupModel.allGroups, groupModel: groupModel)
                PairingListView(userData: userData, viewRouter: viewRouter, myMentors: $myMentors, timerLog: $timerLog, devChats: $devChats)
                    
            }

        }
        .blur(radius: showTimer ? 20 : 0)
        .accentColor(Color("Primary"))
        
        .onAppear {
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                print("iPad")
                self.gridLayout = [GridItem(), GridItem(.flexible())]
            } else {
                orientation = .portrait
            self.gridLayout =  [GridItem(.flexible())]
            }
            groupModel.userData = userData
            groupModel.getAllGroups(){groupModel.allGroups=$0}
            groupModel.getRecentGroups{groupModel.recentGroups=$0}
            groupModel.recentPeople = groupModel.getRecentPeople()
           
        }
        .onRotate { newOrientation in
                    
            if UIDevice.current.userInterfaceIdiom == .phone {
            if !newOrientation.isFlat {
                orientation = newOrientation
            self.gridLayout = (orientation.isLandscape) ? [GridItem(), GridItem(.flexible())] :  [GridItem(.flexible())]
            }
                }
        }
    
        
    }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
    }
    func loadMessageData(){
        let db = Firestore.firestore()
//        let docRef = db.collection("message/\(group.groupID)/messages").order(by: "sentTime", descending: true).limit(to: 1)
//        docRef.getDocuments{ (document, error) in
//                        if let document = document, !document.isEmpty{
//
//
//                        for document in document.documents{
//
//                                   let result = Result {
//                                       try document.data(as: MessageData.self)
//                                   }
//                                   switch result {
//                                       case .success(let messageData):
//                                           if let messageData = messageData {
//                                            messageArray.append(self.parseMessageData(messageData: messageData))
//                                           } else {
//
//                                               print("Document does not exist")
//                                           }
//                                       case .failure(let error):
//                                           print("Error decoding user: \(error)")
//                                       }
//                  }
//                }
//                        print(messageArray)
//                        self.messages = messageArray
//
//        }
    }



        
        
    
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


