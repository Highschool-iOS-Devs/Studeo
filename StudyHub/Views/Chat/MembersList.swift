//
//  MembersList.swift
//  StudyHub
//
//  Created by Andreas on 12/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct MembersList: View {
    @Binding var members: [User]
    @Binding var memberList: Bool
    @Binding var group: Groups
    @Binding var person: User
    @EnvironmentObject var userData:UserData
    @Binding var messages: [MessageData]
    @StateObject var viewModel:RecentsView2ViewModel

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
        
            ForEach(Array(zip(members, viewModel.profileImages)), id: \.0) {item in
                VStack {
                    Button(action: {
                        let groupMemberIDs = [item.0.id.uuidString, userData.userID]
                        let newGroup = Groups(id: UUID().uuidString,
                                          groupID: UUID().uuidString,
                                          groupName: String(describing: userData.name + " and " + item.0.name),
                                          members: groupMemberIDs,
                                          interests: group.interests)
                       
                            self.joinGroup(newGroup: newGroup)
                        memberList = false
                        group = newGroup
                        messages.removeAll()

                    }) {
                        HStack {
                            MemberProfileSubView(size: 75, url: item.1)
                            Text(item.0.name)
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
        .onAppear{
            viewModel.setGroup(group: group)
            viewModel.getProfileImages()
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


struct MemberProfileSubView: View {
    var imagePlaceholder = Image(systemName: "person.circle.fill")
    var size:CGFloat
    var url:URL
    var body: some View {
        KFImage(url, options: [.transition(.fade(0.5)), .processor(DownsamplingImageProcessor(size: CGSize(width: size*3, height: size*3))), .cacheOriginalImage])
            .onSuccess { r in
                 // r: RetrieveImageResult
                 print("success: \(r)")
             }
             .onFailure { e in
                 // e: KingfisherError
                 print("failure: \(e)")
             }
             .placeholder {
                 ProgressView()
             }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: computeLineWidth()))
     
          
    }
    func computeLineWidth() -> CGFloat{
        let lineWidth = 0.046*size
        if lineWidth > 4{
            return 4
        }
        else{
            return lineWidth
        }
    }

  
}
