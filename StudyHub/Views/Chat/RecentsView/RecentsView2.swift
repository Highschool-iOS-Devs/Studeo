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
    var body: some View {
        NavigationView{
            ZStack{
                Color("Background").edgesIgnoringSafeArea(.all)
                ZStack(alignment: .top) {
                    
                    VStack {
                        ScrollView{
                            RecentChatTextRow(add: $add)
                                
                                
                            Spacer()
                            if groupModel.allGroups == [] {
                                
                                Text("You are not in any study group yet,\n\nUse the add button to pair. 🙌").font(Font.custom("Montserrat-Bold", size: 24, relativeTo: .headline)).foregroundColor(Color(#colorLiteral(red: 0.27, green: 0.89, blue: 0.98, alpha: 1)))
                                .multilineTextAlignment(.center)
                                    .frame(width: 250)
                                    .frame(height:425)
                            }
                            else{
                                VStack(spacing: 20) {
                                    if !groupModel.recentGroups.isEmpty {
                                        ForEach(groupModel.recentGroups.indices) { i in//, id: \.groupID){ group in
#warning("maybe the issue is here")
                                            if groupModel.recentGroups.indices.contains(i) {
                                        NavigationLink(
                                           
                                            destination:ChatView(userData: userData, viewRouter: viewRouter, group: $groupModel.recentGroups[i], show: $show)
                                                        
                                            ){
                                            
                                            RecentGroupRowSubview(group: groupModel.recentGroups[i], profilePicture: Image("demoprofile"), userData: userData)
                                                .padding(.horizontal, 20)
                                                .environmentObject(UserData.shared)
                                            
                                        
                                            }
                                        
                                    }
                                    }
                                    Spacer()
                                }
                               
                               
                                
                            }  .padding(.vertical)
                            Spacer()
                            if !groupModel.allGroups.isEmpty {
                            VStack{
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
                                        .environmentObject(UserData.shared)
                                        
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
                                        .environmentObject(UserData.shared)
                                        
                                }
                                }
                            }
                            }
                            Spacer(minLength: 200)
                        }
                      
                    
                    }
                    .frame(width: screenSize.width, height: screenSize.height)
                    .background(Color("Background"))
                    .cornerRadius(20)
                    .offset(y: 15)

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
        .animation(.none)
        .onAppear{
            groupModel.userData = userData
            groupModel.getAllGroups(){groupModel.allGroups=$0}
            groupModel.getRecentGroups{groupModel.recentGroups=$0}
            groupModel.recentPeople = groupModel.getRecentPeople()
        }

    
        
    }

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


