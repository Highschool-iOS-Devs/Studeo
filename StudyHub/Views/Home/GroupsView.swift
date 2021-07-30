//
//  GroupsView.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/21/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct GroupsView: View {
    var imgName:String
    var cta:String
    var name:String
    @ObservedObject var userData: UserData
    @ObservedObject var tabRouter:ViewRouter
    @Binding var group: Groups
    let screenSize = UIScreen.main.bounds
    var body: some View {
        ZStack {
            
            Image(imgName)
                .resizable()
                .scaledToFit()
                .frame(width: screenSize.width/1.5, height: screenSize.width/1.5)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                .padding(.top, 22)
            VStack {
                HStack {
                    Text(name)
                        .foregroundColor(Color("Text"))
                        .font(.headline)
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                
                HStack {
                    Spacer()
                        .padding(.leading, 30)
                    Button(action: {
                        self.userData.tappedCTA = true
                        joinGroup(newGroup: group)
                        
                    }) {
                        Text(cta)
                            .font(.headline)
                            .multilineTextAlignment(.trailing)
                        
                        
                        
                    } .buttonStyle(BlueStyle())
                    .shadow(radius: 5)
                    .offset(y: -30)
                }
                
            }
            
            
        }
    }
    func joinGroup(newGroup: Groups) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        group.members.append(userData.userID)
        do{
            try docRef.document(group.groupID).setData(from: group)
            
        }
        catch{
            print("Error writing to database, \(error)")
        }
        
        let ref = db.collection("users").document(self.userData.userID)
        ref.getDocument{document, error in
            
            if let document = document, document.exists {
                
                
                let groupListCast = document.data()?["groups"] as? [String]
                
                if var currentGroups = groupListCast {
                    
                    guard !(groupListCast?.contains(newGroup.groupID))! else{return}
                    currentGroups.append(newGroup.groupID)
                    
                    ref.updateData(
                        [
                            "groups": currentGroups
                        ]
                    )
                } else {
                    ref.updateData(
                        [
                            "groups":[group.groupID]
                        ]
                    )
                }
            } else {
                print("Error getting user data, \(error!)")
            }
        }
    }
}

