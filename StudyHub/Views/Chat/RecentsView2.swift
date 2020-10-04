//
//  RecentsView2.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//Currently recent view will display all users because chatting is not set up yet
struct RecentsView2: View {
    //List for UI displaying the list of people
    @State var recentPeople = [Groups]()
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: ViewRouter
    
    //For passing information into chat view. When user taps on a people in the scroll list, it should take user to the chat view.
    
    var body: some View {
        VStack {
            Spacer()
            VStack{
                Text("Recent Chats")
                    .font(.custom("Montserrat-Bold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.vertical, 30)
                
                ForEach(recentPeople){user in
                    RecentPersonView(name: user.groupName, group: user)
                        .onTapGesture {
                            
                    }
                }
                
                Spacer()
            }
            .frame(height: 600)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
                .offset(x: 0, y: 50)
                .onAppear{
                    self.loadData(){userData in
                        //Get completion handler data results from loadData function and set it as the recentPeople local variable
                        self.recentPeople = userData
                    }
            }
        }
    }
    
    func loadData(performAction: @escaping ([Groups]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        var userList:[Groups] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        queryParameter.getDocuments{ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: Groups.self)
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
