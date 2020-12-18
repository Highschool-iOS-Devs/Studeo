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
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var tabRouter:ViewRouter
    @Binding var group: Groups
    let screenSize = UIScreen.main.bounds
    @Binding var chat: Bool
    var body: some View {
        ZStack {
        
        Image(imgName)
            .resizable()
            .scaledToFit()
            .frame(width: screenSize.width/1.5, height: screenSize.width/1.5)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
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
                        chat = true
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
        do{
            try docRef.document(newGroup.groupID).setData(from: newGroup)
            
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
                            "groups":[newGroup.groupID]
                        ]
                    )
                }
            } else {
                print("Error getting user data, \(error!)")
            }
        }
        chat = true
    }
}

