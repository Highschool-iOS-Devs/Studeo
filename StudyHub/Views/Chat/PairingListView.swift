//
//  PairingListView.swift
//  PairingListView
//
//  Created by Andreas on 7/27/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PairingListView: View {
    //    @State var allGroups: [Groups] = []
    //    @State var recentPeople: [User] = []
    //    @State var recentGroups: [Groups] = []
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter: ViewRouter
    @StateObject var groupModel = ChatViewModel()
    @State var add: Bool = false
    @State var settings: Bool = false
    @State var showChat: Bool = false

    @State var showTimer = false
    @Binding var myMentors:[Groups]
    @Binding var timerLog: [TimerLog]
    @Binding var devChats:[Groups]
    @State var lookingForMentor = false
    @Environment(\.presentationMode) var presentationMode
    @State var selectedInterests:[UserInterestTypes] = []
    @State var interests:[String] = []
    @State var show = false
    
    var body: some View {
        NavigationView{
            ZStack{
                Color("Background").edgesIgnoringSafeArea(.all)
                ZStack(alignment: .top) {
                    
                    VStack {
                        HStack {
                            
                            Image(systemName: "gear")
                                .font(.largeTitle)
                                
                                .opacity(0.7)
                                .onTapGesture {
                                    settings.toggle()
                                }
                            if !lookingForMentor {
                            } else {
                                Button(action: {
                                    add = true
                                    
                                }) {
                                    Image(systemName: "plus")
                                        
                                        .font(.largeTitle)
                                    
                                    
                                    
                                }
                            }
                            Spacer()
                            
                            Button(action: {
                                if lookingForMentor {
                                    
                                    viewRouter.updateCurrentView(view: .home)
                                }
                                presentationMode.wrappedValue.dismiss()
                                
                                
                            }) {
                                Image(systemName: "xmark")
                                    
                                    .font(.largeTitle)
                                
                                
                                
                            }
                            
                        } .padding()
                        
                        
                        ScrollView{
                            //                            RecentChatTextRow(add: $add)
                            //
                            
                            //Spacer()
                            //                            if groupModel.allUnjoinedGroups == [] {
                            //
                            //                                Text("You are not in any study group yet,\n\nUse the add button to pair. 🙌").font(Font.custom("Montserrat-Bold", size: 24, relativeTo: .headline)).foregroundColor(Color(#colorLiteral(red: 0.27, green: 0.89, blue: 0.98, alpha: 1)))
                            //                                .multilineTextAlignment(.center)
                            //                                    .frame(width: 250)
                            //                                    .frame(height:425)
                            //                            }
                            //                            else{
                            //                                VStack(spacing: 20) {
                            //                                    if !groupModel.recentGroups.isEmpty {
                            //                                        ForEach(groupModel.recentGroups.indices) { i in//, id: \.groupID){ group in
                            //#warning("maybe the issue is here")
                            //                                            if groupModel.recentGroups.indices.contains(i) {
                            //                                        NavigationLink(
                            //
                            //                                            destination:ChatView(group: $groupModel.recentGroups[i], show: $show)
                            //
                            //                                            ){
                            //
                            //                                            RecentGroupRowSubview(group: groupModel.recentGroups[i], profilePicture: Image("demoprofile"))
                            //                                                .padding(.horizontal, 20)
                            //                                                .environmentObject(UserData.shared)
                            //
                            //                                        }
                            //                                            }
                            //
                            //                                    }
                            //                                    }
                            //                                    Spacer()
                            //                                }
                            //   .padding(.vertical)
                            
                            
                            //                            }
                            //                            Spacer()
                            if !groupModel.allUnjoinedGroups.isEmpty {
                                VStack{
                                    AllGroupTextRow()
                                    
                                    LazyVGrid(columns: gridItemLayout, spacing: 40){
                                        ForEach($groupModel.allUnjoinedGroups) { group in//, id: \.groupID){group in
                                            
                                            Button(action: {
                                                if lookingForMentor {
                                                    createMentorship(group: group.wrappedValue)
                                                } else {
                                                    joinExistingGroup(groupID: group.wrappedValue.groupID)
                                                }
                                                showChat = true
                                            }) {
                                               
                                                RecentChatGroupSubview2(group: group.wrappedValue, userData: userData, viewRouter: viewRouter)
                                                
                                                
                                            } .fullScreenCover(isPresented: $showChat) {
                                                ChatView(userData: userData, viewRouter: viewRouter, group: group, show: $show, hideNavBar: .constant(false))
                                                               
                                            }
                                        
                                        
                                    }
                                    }
                                }
                            } else {
                                EmptyView()
                                    .onAppear() {
                                        createNewGroup()
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
                                            destination:ChatView(userData: userData, viewRouter: viewRouter, group: $myMentors[i], show: $show, hideNavBar: .constant(false))
                                            
                                            
                                        ){
                                            RecentChatGroupSubview(group: myMentors[i], userData: userData, viewRouter: viewRouter, hideNavBar: .constant(false))
                                            
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
                                        
                                        RecentChatGroupSubview(group:devChats[i], userData: userData, viewRouter: viewRouter, hideNavBar: .constant(false))
                                        
                                        
                                        
                                        
                                    }
                                }
                            }
                            Spacer(minLength: 200)
                        }
                        
                        
                    }
                    
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
                if settings {
                    
                    IntroCustomize(interestSelected: $selectedInterests, userData: userData, isNotOnboarding: false, interests: $interests, settings: $settings, add: $add, viewRouter: viewRouter, groupModel:groupModel)
                    
                }
            } .navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.top)
            .onAppear{
                groupModel.userData = userData
                
                groupModel.getCurrentOrAnyUser(userID: userData.userID) { value in
                    groupModel.currentUser = value
                    lookingForMentor ? groupModel.getAllUnJoinedmentors(){groupModel.allUnjoinedGroups=$0} : groupModel.getAllUnJoinedGroups(){groupModel.allUnjoinedGroups=$0}
                    selectedInterests = value.interests ?? [UserInterestTypes]()
                    interests = value.interests.map{$0.map{$0.rawValue}} ?? [String]()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        if groupModel.allUnjoinedGroups == [] {
                            createNewGroup()
                        }
                    }
                }
                //            groupModel.getRecentGroups{groupModel.recentGroups=$0}
                //            groupModel.recentPeople = groupModel.getRecentPeople()
            }
            
            .onChange(of: groupModel.allUnjoinedGroups) { value in
                if groupModel.allUnjoinedGroups == [] {
                    createNewGroup()
                }
            }
            
            .fullScreenCover(isPresented: $add){
                IntroMentor(userData: userData, viewRouter: viewRouter, isNotOnboarding: true)
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .blur(radius: showTimer ? 20 : 0)
        .accentColor(Color("Primary"))
        .animation(.none)
        
        
        
    }
    func createNewGroup() {
        let interest = groupModel.currentUser?.interests?.first ?? .Algebra1
        let group = Groups(id: UUID().uuidString, groupID: UUID().uuidString, groupName: interest.rawValue + " Group" , members: [], membersCount: 0, interests: [interest])
        
        let db = Firestore.firestore()
        let ref = db.collection("groups").document(group.groupID)
        do {
            try ref.setData(from: group)
            groupModel.allUnjoinedGroups.append(group)
            
        } catch {
            print(error)
        }
    }
    func createMentorship(group: Groups) {
        let db = Firestore.firestore()
        let ref = db.collection("groups").document(group.groupID)
        do {
            try ref.setData(from: group)
        } catch {
            print(error)
        }
    }
    func joinExistingGroup(groupID:String){
        let db = Firestore.firestore()
        let ref = db.collection("groups").document(groupID)
        ref.updateData([
            "members" : FieldValue.arrayUnion([userData.userID]),
            "membersCount" : FieldValue.increment(Int64(1))
        ])
        let ref2 = db.collection("users").document(userData.userID)
        ref2.updateData([
            "groups":FieldValue.arrayUnion([groupID])
        ])
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
