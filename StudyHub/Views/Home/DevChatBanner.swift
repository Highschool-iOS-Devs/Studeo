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
    @ObservedObject var viewRouter:ViewRouter
    @ObservedObject var userData:UserData
    ///DevGroup
    @Binding var devGroup: Groups
    @Binding var show: Bool
    var body: some View {
        NavigationView{
            ZStack {
                Color("Primary")
                    
                    .ignoresSafeArea()
                    
                    .onAppear() {
                        
                    }
                HStack {
                    VStack {
                        Text("Have a question or feedback?")
                            .font(Font.custom("Montserrat-Bold", size: 16, relativeTo: .subheadline))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding()
                        
                        ///NavigationLink that takes user directly to the talk with developer chat, without going through viewRouter
                        Button(action: {
                            joinGroup(newGroup: devGroup)
                            show = true
                            self.userData.hasDev = true
                        }) {
                            
                            
                            
                            Text("Talk directly to a developer of this app")
                                .font(Font.custom("Montserrat-SemiBold", size: 14, relativeTo: .subheadline))
                                .foregroundColor(Color("Primary"))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white))
                                .multilineTextAlignment(.center)
                                .padding()
                        } 
                        
                        .navigationTitle("")
                        .navigationBarHidden(true)
                        
                        
                    }
                    
                } // .animation(.linear(duration: 2.0))
            }
        } .frame(maxHeight: 400)
        
        
        
    }
    func joinGroup(newGroup: Groups) {
        let db = Firestore.firestore()
        let docRef = db.collection("devChat")
        devGroup.members.append("6888DA56-1995-46ED-9B79-F1056D363D6F")
        devGroup.members.append(userData.userID)
        do{
            try docRef.document(devGroup.groupID).setData(from: devGroup)
            
        }
        catch{
            print("Error writing to database, \(error)")
        }
        
        
        
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
