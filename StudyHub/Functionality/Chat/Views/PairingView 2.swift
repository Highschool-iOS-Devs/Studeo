//
//  PairingView.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase

struct PairingView: View {
    @State var matchedPerson = BasicUser(id: "", name: "")
    @State var people = [BasicUser]()
    @EnvironmentObject var userData:UserData
    @State var paired: Bool = false
    @State var selectedInterests:[String] = []
    @Binding var myGroups:[Groups]
    @State var colorPick = Color.white
    @State var groupName = ""
    @State var newGroup = Groups(id: "", groupName: "", groupID: "", createdBy: "", members: [""], interests: [""])
    var body: some View {
        ZStack {
            Color(.white)
            .onAppear() {
        self.loadData(){userData in
            //Get completion handler data results from loadData function and set it as the recentPeople local variable
            self.people = userData
           
        
        }
            }
            
            VStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("3566801")
                            
                            .renderingMode(.original)
                            
                            .resizable()
                            // .frame(width: 350, height: 350)
                            
                            .scaledToFit()
                        Spacer()
                    }
                    Spacer()
                }
                Button(action: {
                    
                    self.matchedPerson = self.people.randomElement()!
                    
                    if matchedPerson.id != userData.userID {
//                        self.matchedPerson = self.people.randomElement()!
                        print(self.matchedPerson.name)
                        newGroup = Groups(id: UUID().uuidString, groupName: self.groupName, groupID: UUID().uuidString, createdBy: self.userData.userID, members: [self.userData.userID, self.matchedPerson.id], interests: self.selectedInterests)
                        self.joinGroup(newGroup: newGroup)
                        paired = true
                    } else {
                        print("You got here")
                    }
                    
                }) {
                    Text("Pair")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                } .buttonStyle(BlueStyle())
                .padding()
                
            }
            if paired {
                ChatView(userData: _userData, chatRoomID: newGroup.groupID)
            }
    }
    }
            
    
    func loadData(performAction: @escaping ([BasicUser]) -> Void){
           let db = Firestore.firestore()
           let docRef = db.collection("users")
           var userList:[BasicUser] = []
           //Get every single document under collection users
       
        docRef.getDocuments{ (querySnapshot, error) in
               for document in querySnapshot!.documents{
                   let result = Result {
                       try document.data(as: BasicUser.self)
                   }
                   switch result {
                       case .success(let user):
                           if let user = user {
                               userList.append(user)
                    
                           } else {
                               
                               print("Document does not exist")
                           }
                       case .failure(let error):
                           print("Error decoding user: \(error)")
                       }
                   
                 
               }
                 performAction(userList)
           }
           
           
       }
    func joinGroup(newGroup:Groups){
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        do{
            try docRef.document(newGroup.groupID).setData(from: newGroup)

        }
        catch{
            print("Error writing to database, \(error)")
        }
                
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
                              
                              guard !(groupListCast?.contains(newGroup.groupID))! else{return}
                              currentGroups.append(newGroup.groupID)
                              ref.updateData(
                                    [
                                        "groups":currentGroups
                                    ]
                                )
                          }
                          else{
                              ref.updateData(
                              [
                                  "groups":[newGroup.groupID]
                              ]
                          )
                          }
                      }
                      else{
                          print("Error getting user data, \(error!)")
                      }
                  }
                  


  }

}



struct PairingView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
