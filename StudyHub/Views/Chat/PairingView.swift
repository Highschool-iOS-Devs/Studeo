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
                        self.matchedPerson = self.people.randomElement()!
                        print(self.matchedPerson.name)
                    }
                    
                }) {
                    Text("Pair")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                } .buttonStyle(BlueStyle())
                .padding()
                
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
}

struct PairingView_Previews: PreviewProvider {
    static var previews: some View {
        PairingView()
    }
}
