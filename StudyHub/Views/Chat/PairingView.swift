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
    @State var matchedPerson = User(id: UUID(), firebaseID: "", name: "", email: "", image: "", interests: [""], groups: [""], studyHours: 0.0, studyDate: "", all: 0.0, month: 0.0, day: 0.0, description: "")
    @State var people = [User]()
    @EnvironmentObject var userData:UserData
    @State var paired: Bool = false
    @Binding var settings: Bool
    @Binding var add: Bool 
    @State var selectedInterests:[String] = []
    @Binding var myGroups:[Groups]
    @State var colorPick = Color.white
    @State var groupName = ""
    @State var newGroup = Groups(id: "", groupName: "", groupID: "", createdBy: "", members: [""], interests: [""])
    @State var interests = [String]()
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
            HStack {
                Spacer()
                Image(systemName: "gear")
                    .font(.largeTitle)
                   
                    .opacity(0.7)
                    .onTapGesture {
                        settings.toggle()
                    }
            }
                Spacer()
            } .padding()
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
                    if people.count > 0 {
                    self.matchedPerson = self.people.randomElement()!
                    
                        if matchedPerson.id.uuidString != userData.userID {
//                        self.matchedPerson = self.people.randomElement()!
                        print(self.matchedPerson.name)
                            newGroup = Groups(id: UUID().uuidString, groupName: matchedPerson.name + " and " + userData.name, groupID: UUID().uuidString, createdBy: self.userData.userID, members: [self.userData.userID, self.matchedPerson.id.uuidString], interests: self.selectedInterests)
                        self.joinGroup(newGroup: newGroup)
                        paired = true
                    } else {
                        print("You paired with yourself")
                    }
                    } else {
                        print("no one to pair with")
                    }
                }) {
                    Text("Pair")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                } .buttonStyle(BlueStyle())
                .padding()
                Spacer(minLength: 150)
            }
            
            .sheet(isPresented: self.$paired){
                ChatView(userData: _userData, group: newGroup, chatRoomID: $newGroup.groupID)
                    .environmentObject(userData)
            }
                
            VStack {
                HStack {
                    Button(action: {
                       
                        if !settings {
                            add = false
                        }
                        if settings {
                            settings = false
                        }
                       
                        
                    }) {
                    Image(systemName: "xmark")
                        .font(.largeTitle)
                    
                    
                    
                }
                    Spacer()
                }
                Spacer()
            } .padding()
            
            if settings {
                
                IntroCustomize(isNotOnboarding: true, interests: $interests, settings: $settings, add: $add)
             
            }
            
    }
    }
            
    
    func loadData(performAction: @escaping ([User]) -> Void){
        
        let db = Firestore.firestore()
        let ref = db.collection("users").document(self.userData.userID)
        ref.getDocument{document, error in
            
            if let document = document, document.exists {
                
                //Cast groupList property from Any to String
                //Note: We are not using the decoding struct method because we only need 1 property, not the entire user object
                interests = (document.data()?["interests"] as? [String])!
                
        for interest in interests {
          
        let docRef = db.collection("users").whereField("interests", arrayContains: interest)
           var userList:[User] = []
           //Get every single document under collection users
       
        docRef.getDocuments{ (querySnapshot, error) in
               for document in querySnapshot!.documents{
                   let result = Result {
                       try document.data(as: User.self)
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
           
       }
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


