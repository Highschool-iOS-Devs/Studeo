//
//  CreateGroupView.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/6/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

struct CreateGroupView: View {
    @Binding var presentCreateView:Bool
    @State var selectedInterests:[String] = []
    @EnvironmentObject var userData:UserData
    @State var colorPick = Color.white
    @State var groupName = ""
    var body: some View {
        VStack {
            Text("New Group")
                .font(.custom("Montserrat-Bold", size: 27))
            Text("Group Name")
            .font(.custom("Montserrat", size: 18))
                .foregroundColor(Color.black.opacity(0.4))
                .padding(.top, 80)
            TextField("Your group name", text: $groupName)
                .font(.custom("Montserrat-Semibold", size: 23))
                .frame(width: 300)
                .multilineTextAlignment(.center)
            Divider()
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
            
            Text("Group topics")
                .frame(maxWidth: .infinity, alignment: .leading)
                 .font(.custom("Montserrat", size: 18))
                .foregroundColor(Color.black.opacity(0.4))
                .padding(.leading, 20)
                .padding(.bottom, 30)
            HStack {
                CategoriesTag(displayText: "SAT", selectedInterests: $selectedInterests)
                CategoriesTag(displayText: "ACT", selectedInterests: $selectedInterests)
                CategoriesTag(displayText: "AP Calculus", selectedInterests: $selectedInterests)
                CategoriesTag(displayText: "AP Physics", selectedInterests: $selectedInterests)
            }
            
            Spacer()
            Button(action: {
                let db = Firestore.firestore()
                let docRef = db.collection("groups")
                let newGroup = Groups(groupName: self.groupName, groupID: UUID().uuidString, createdBy: self.userData.userID, members: [self.userData.userID], interests: [])
                do{
                    try docRef.document(newGroup.groupID).setData(from: newGroup)
                    self.presentCreateView = false
                    self.joinGroup(groupID: newGroup.groupID)
                    
                }
                catch{
                    print("Error writing to database, \(error)")
                }
                
            })
            {
                Text("CREATE GROUP")
                    .font(.custom("Montserrat-bold", size: 15))
            }
            .buttonStyle(BlueStyle())
            .padding(.horizontal, 30)
            .padding(.bottom, 50)
            //For some reason this line is needed to fix preview crasing
            .onAppear{
                //FirebaseApp.configure()
            }
        }
    }
    func joinGroup(groupID: String){
           let db = Firestore.firestore()
           //Set reference to the group that the user pressed on (groupID provided by the function caller)
           let docRef = db.collection("groups").document(groupID)
           var groupMembers:[String] = []
           //Because Firebase provide no built in append function, have to use a 3 step process
               //Step 1: Get the group member list from Firebase group item, and store it in local variable
               //Step 2: Append current user into that local variable list
               //Step 3: Update the local variable list onto Firebase
               
           docRef.getDocument{ (document, error) in
               let result = Result {
                   try document?.data(as: Groups.self)
               }
               switch result {
               //Decode sucess
               case .success(let group):
                   
                   //Make sure group is not nil
                   
                   if let group = group {
                       //Set local variable to Firebase data
                       groupMembers = group.members
                       
                       //Immediately update UI by appending this group into myGroups
                      // self.myGroups.append(group)
                       
                       //Now time for adding the groupID information in this user's document, under groups property
                       //Same 3 step technique as mentioned above
                       let ref = db.collection("users").document(self.userData.userID)
                       ref.getDocument{document, error in
                           
                           if let document = document, document.exists {
                               
                               //Cast groupList property from Any to String
                               //Note: We are not using the decoding struct method because we only need 1 property, not the entire user object
                               let groupListCast = document.data()?["groups"] as? [String]
                               
                               //Check if make sure user's groups is not nil, which might happen if it is first time a user joining a group. If is nil, will update with only the current group. If not will append then update.
                               if var currentGroups = groupListCast{
                                   
                                   guard !(groupListCast?.contains(group.groupID))! else{return}
                                   currentGroups.append(group.groupID)
                                   ref.updateData(
                                         [
                                             "groups":currentGroups
                                         ]
                                     )
                               }
                               else{
                                   ref.updateData(
                                   [
                                       "groups":[group.groupID]
                                   ]
                               )
                               }
                           }
                           else{
                               print("Error getting user data, \(error!)")
                           }
                       }
                       
                   } else {
                       print("Document does not exist")
                   }
               case .failure(let error):
                   print("Error decoding group: \(error)")
               }
               //Make sure a group does not have 2 same userID, because cannot join a group twice
               if groupMembers.contains(self.userData.userID){
                   return
               }
               groupMembers.append(self.userData.userID)
               
                   
               docRef.updateData(
                   [
                       "members" : groupMembers
                   ]
               ){error in
                   if let error = error{
                       print("Error updating user to join group, \(error)")
                   }
               }
               
           }
}
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(presentCreateView: .constant(false))
    }
}

struct CategoriesTag: View {
    var displayText:String
    @State var selected = false
    @Binding var selectedInterests:[String]
    var body: some View {
        Text(displayText)
            .font(.custom("Montserrat-Bold", size: 15))
            .frame(width: CGFloat(60+10*(displayText.count)), height: 30)
            .foregroundColor(.white)
            .background(selected ? Color.yellow : Color.yellow.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .onTapGesture {
                self.selected.toggle()
                self.selectedInterests.append(self.displayText)
        }
        .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
    }
}
