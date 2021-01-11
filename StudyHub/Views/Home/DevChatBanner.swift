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
    @Binding var devGroup: Groups
    @Binding var show: Bool
    var body: some View {
        NavigationView{
            ZStack {
                Color("Primary")
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 2.0))
                    .onAppear() {
                        
                    }
                HStack {
                    VStack {
                    Text("Have a question or feedback?")
                        .font(Font.custom("Montserrat-Bold", size: 18, relativeTo: .headline))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding()
                        ///NavigationLink that takes user directly to the talk with developer chat, without going through viewRouter
                        Button(action: {
                            joinGroup(newGroup: devGroup)
                            show = true
                        }) {
                            
                        
                           
                                Text("Talk directly to a developer of this app")
                                    .font(Font.custom("Montserrat-SemiBold", size: 12, relativeTo: .subheadline))
                                    .foregroundColor(Color("Primary"))
                                    .padding()
                                    .background(RoundedRectangle(cornerRadius: 25).foregroundColor(.white))
                            
                            .padding()
                        } 
                        .frame(height: 60)
                        .navigationTitle("")
                        .navigationBarHidden(true)
                      
                        
                        }
                   
                } // .animation(.linear(duration: 2.0))
            }
        } .frame(height: 220)
        
       
    
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
        
        devGroup.members.append("6888DA56-1995-46ED-9B79-F1056D363D6F")
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
