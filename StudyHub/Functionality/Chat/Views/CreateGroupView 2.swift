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
    @Binding var myGroups:[Groups]
    @State var colorPick = Color.white
    @State var groupName = ""
    
    var body: some View {
        VStack {
            Text("New Group")
                .font(.custom("Montserrat-Bold", size: 27))
                .padding(.top, 20)
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
                .frame(width: screenSize.width, alignment: .leading)
                 .font(.custom("Montserrat", size: 18))
                .foregroundColor(Color.black.opacity(0.4))
                .padding(.leading, 20)
                .padding(.bottom, 30)
            ScrollView(.horizontal, showsIndicators: false) {
              
               
            HStack {
                Spacer()
                CategoriesTag(displayText: "SAT", selectedInterests: $selectedInterests)
                Spacer()
                CategoriesTag(displayText: "ACT", selectedInterests: $selectedInterests)
                Spacer()
                CategoriesTag(displayText: "AP Calculus", selectedInterests: $selectedInterests)
                Spacer()
                CategoriesTag(displayText: "AP Physics", selectedInterests: $selectedInterests)
                Spacer()
                
            } .padding()
            }
            
            Spacer()
            Button(action: {
                let newGroup = Groups(id: UUID().uuidString, groupName: self.groupName, groupID: UUID().uuidString, createdBy: self.userData.userID, members: [self.userData.userID], interests: self.selectedInterests)
                self.joinGroup(newGroup: newGroup)
                
            })
            {
                Text("CREATE GROUP")
                    .font(.custom("Montserrat-bold", size: 15))
            }
            .buttonStyle(BlueStyle())
            .padding()

            .padding(.bottom, 50)
            //For some reason this line is needed to fix preview crasing
            .onAppear{
                //FirebaseApp.configure()
            }
        }
    }
      //Called when user taps and joins a new group. Adds the user to group, and adds the group to user
        func joinGroup(newGroup:Groups){
            let db = Firestore.firestore()
            let docRef = db.collection("groups").document(newGroup.groupID)
            do{
                try docRef.setData(from: newGroup)
           
                       }
                       catch{
                           print("Error writing to database, \(error)")
                       }
         
            
            let userDocRef = db.collection("user").document(userData.userID)
            userDocRef.updateData(
                [
                    "groups":FieldValue.arrayUnion([newGroup.groupID])
                ]
            )


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
