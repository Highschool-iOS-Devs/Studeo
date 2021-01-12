//
//  OtherUserProfileView.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/24/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import KingfisherSwiftUI

struct OtherUserProfileView: View {
    @State var profileImageURL:URL?
    var user:User
    @State var alreadyHaveDM = true
    @EnvironmentObject var userData:UserData
    @Environment(\.presentationMode) var presentationMode
    @Binding var showMemberList:Bool
    var body: some View {
        GeometryReader { geo in
             ZStack {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                
                 VStack {
                    
                    ProfileRingView(imageURL:profileImageURL, size: geo.size.width-100)

                    Text(user.name)
                        // .frame(minWidth: 100, alignment: .leading)
                        .font(Font.custom("Montserrat-SemiBold", size: 22, relativeTo: .headline))
                         .foregroundColor(Color("Text"))
                         .multilineTextAlignment(.leading)
                        .padding(.vertical, 15)
                    
                    Divider()
                        .foregroundColor(Color("Primary"))
                    
                     HStack {
                       
                        ProfileStats(allNum: 0, all: true)
                        ProfileStats(monthNum: 0, month: true)
                        ProfileStats(dayNum: 0, day: true)
                       
                     }
                     .padding(.bottom, 15)
                     .padding(.top, 40)
                    
                    Text(user.description)
                         .frame(minWidth: 100, alignment: .center)
                        .font(Font.custom("Montserrat-SemiBold", size: 16, relativeTo: .headline))
                         .foregroundColor(Color("Text"))
                         .multilineTextAlignment(.center)
                        .padding(.bottom, 22)
                    //if !alreadyHaveDM{
                        Button(action: {
                            let groupMemberIDs = [user.id.uuidString, userData.userID]
                            let id = UUID().uuidString
                            let newGroup = Groups(id: id,
                                                  groupID: id,
                                              groupName: String(describing: userData.name + " and " + user.name),
                                              members: groupMemberIDs,
                                              membersCount: groupMemberIDs.count,
                                              interests: [nil], userInVC: [String]())

                                self.joinGroup(newGroup: newGroup)
                            presentationMode.wrappedValue.dismiss()
                            showMemberList = false
    //                        group = newGroup
    //                        messages.removeAll()
                            
                        }){
                           // Text("Private message")
                             //   .font(Font.custom("Montserrat-Bold", size: 16, relativeTo: .headline))
                        }
                        .frame(height:50)
                        .buttonStyle(BlueStyle())
                        .padding(.bottom)
                   // }
          
                   Spacer()
                 }
                 .padding(.horizontal)
                
             }
        }.onAppear{
            downloadImages()
            checkIfAlreadyDM()
            
        }
    }
        func downloadImages(){
             let metadata = StorageMetadata()
             metadata.contentType = "image/jpeg"
    
             let storage = Storage.storage()
            let pathReference = storage.reference(forURL: "gs://study-hub-7540b.appspot.com/User_Profile/\(user.id)")
            pathReference.downloadURL { url, error in
                if let error = error {
                  print("Error downloading image, \(error)")
                } else {
                    profileImageURL = url!
                }
              }
    
         }
    func checkIfAlreadyDM(){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userID)
        docRef.getDocument{document, error in
            guard error == nil else {return}
            if let document = document{
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                    case .success(let user):
                        if let userDM = user?.dms {
                            if userDM.contains(self.user.id.uuidString){
                                alreadyHaveDM = true
                            }
                            else{
                                alreadyHaveDM = false
                            }

                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
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
        
        for member in newGroup.members {
            print(member)
        let ref2 = db.collection("users").document(member)
        ref2.getDocument{document, error in
            
            if let document = document, document.exists {
                
         
                let groupListCast = document.data()?["dms"] as? [String]
                
                if var currentGroups = groupListCast{
                    
                    guard !(groupListCast?.contains(newGroup.groupID))! else{return}
                    currentGroups.append(newGroup.groupID)
                    ref2.updateData(
                        [
                            "dms":currentGroups
                        ]
                    )
                } else {
                    ref2.updateData(
                        [
                            "dms":[newGroup.groupID]
                        ]
                    )
                }
            } else {
                print("Error getting user data, \(error!)")
            }
        }
    }    }

}

