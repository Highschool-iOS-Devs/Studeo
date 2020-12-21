//
//  MembersList.swift
//  StudyHub
//
//  Created by Andreas on 12/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase

struct MembersList: View {
    @Binding var members: [User]
    @Binding var memberList: Bool
    @Binding var group: Groups
    @Binding var person: User
    @EnvironmentObject var userData:UserData
    @Binding var messages: [MessageData]
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
        VStack {
            HStack {
                
                Button(action: {
                    memberList = false
                    
                }) {
                    Image(systemName: "xmark")
                }
                Spacer()
            } .padding()
        
            ForEach(members) { member in
                VStack {
                    Button(action: {
                        let groupMemberIDs = [member.id.uuidString, userData.userID]
                        let newGroup = Groups(id: UUID().uuidString,
                                          groupID: UUID().uuidString,
                                          groupName: String(describing: self.group.interests[0]!),
                                          members: groupMemberIDs,
                                          interests: group.interests)
                       
                            self.joinGroup(newGroup: newGroup)
                        memberList = false
                        group = newGroup
                        messages.removeAll()
                        
                    }) {
                        HStack {
                           ProfileRingView(imagePlaceholder: Image("person"), size: 75)
                        Text(member.name)
                            .font(.custom("Montserrat", size: 24))
                            .foregroundColor(.black)
                            .padding()
                            Spacer()
                        } .padding()
                   
                }
            Divider()
        }
               
            }
            Spacer()
        }
    }
    }
    func joinGroup(newGroup:Groups) {
        let db = Firestore.firestore()
        let docRef = db.collection("dms")
        do{
            try docRef.document(newGroup.groupID).setData(from: newGroup)
            
        }
        catch{
            print("Error writing to database, \(error)")
        }
        
        let ref = db.collection("users").document(self.userData.userID)
        ref.getDocument{document, error in
            
            if let document = document, document.exists {
                
         
                let groupListCast = document.data()?["dms"] as? [String]
                
                if var currentGroups = groupListCast{
                    
                    guard !(groupListCast?.contains(newGroup.groupID))! else{return}
                    currentGroups.append(newGroup.groupID)
                    ref.updateData(
                        [
                            "dms":currentGroups
                        ]
                    )
                } else {
                    ref.updateData(
                        [
                            "dms":[newGroup.groupID]
                        ]
                    )
                }
            } else {
                print("Error getting user data, \(error!)")
            }
        }
    }
}


