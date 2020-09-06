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

struct CreateGroupView: View {
    @Binding var groupListView:[GroupListView]
    @EnvironmentObject var userData:UserData
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
                .frame(width: 200, alignment: .center)
            Spacer()
            Button(action: {
                let db = Firestore.firestore()
                let docRef = db.collection("groups")
                let newGroup = Groups(groupName: "SAT", groupID: UUID().uuidString, createdBy: self.userData.userID, members: [self.userData.userID], interests: ["SAT","Exam"])
                do{
                    try docRef.document(newGroup.groupID).setData(from: newGroup)
                    self.groupListView.append(GroupListView(titleText: "SAT"))
                    
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
            .padding(.bottom, 200)
            //For some reason this line is needed to fix preview crasing
            .onAppear{
                FirebaseApp.configure()
            }
        }
    }
}

struct CreateGroupView_Previews: PreviewProvider {
    static var previews: some View {
        CreateGroupView(groupListView: .constant([GroupListView]()))
    }
}
