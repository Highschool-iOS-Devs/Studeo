//
//  DevChatBanner.swift
//  StudyHub
//
//  Created by Andreas on 12/21/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct DevChatBanner: View {
    @EnvironmentObject var viewRouter:ViewRouter
    @EnvironmentObject var userData:UserData
    ///DevGroup
    @State var devGroup = Groups(id: "", groupID: UUID().uuidString, groupName: "Andreas", members: [String](), membersCount: 0, interests: [UserInterestTypes?](), recentMessage: "", recentMessageTime: Date())
    var body: some View {
        NavigationView{
            ZStack {
                Color("Primary")
                    .ignoresSafeArea()
                    .frame(height: 200)
                HStack {
                    VStack {
                    Text("Have a question or feedback?")
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundColor(.white)
                        .padding()
                        ///NavigationLink that takes user directly to the talk with developer chat, without going through viewRouter
                        NavigationLink(destination: ChatView(group: devGroup)
                                                        .onAppear() {
                                                            viewRouter.showTabBar = false
                                                            joinGroup(newGroup: devGroup)
                                                            userData.hasDev = true
                                                        }
                        ){
                            Button(action: {
                            }) {
                                Text("Talk directly to a developer of this app")
                                    .font(.custom("Montserrat-Semibold", size: 12))
                                    .foregroundColor(Color("Primary"))
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white))
                            }
                            .padding()
                        }
                        .navigationTitle("")
                        .navigationBarHidden(true)
                      
                        
                        }
                   
                }
            }
        }
    
    }
    func joinGroup(newGroup: Groups) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        do{
            try docRef.document(newGroup.groupID).setData(from: newGroup)
            
        }
        catch{
            print("Error writing to database, \(error)")
        }
        
        devGroup.members.append("n3SQZeq1oMhJzHNd1WlMSEClLHp2")
        devGroup.members.append(userData.userID)
        for member in devGroup.members {
            print(member)
        let ref2 = db.collection("users").document(member)
        ref2.getDocument{document, error in
            
            if let document = document, document.exists {
                
         
                let groupListCast = document.data()?["groups"] as? [String]
                
                if var currentGroups = groupListCast{
                    
                    guard !(groupListCast?.contains(newGroup.groupID))! else{return}
                    currentGroups.append(newGroup.groupID)
                    ref2.updateData(
                        [
                            "groups":currentGroups
                        ]
                    )
                } else {
                    ref2.updateData(
                        [
                            "groups":[newGroup.groupID]
                        ]
                    )
                }
            } else {
                print("Error getting user data, \(error)")
            }
        }
    }
    }
}

//struct DevChatBanner_Previews: PreviewProvider {
//    static var previews: some View {
//        DevChatBanner()
//    }
//}
