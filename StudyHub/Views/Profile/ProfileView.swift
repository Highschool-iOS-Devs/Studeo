//
//  ProfileView.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore
import UIKit

 struct ProfileView: View {
    @State var profileImage:UIImage?
    @State var hasLoaded: Bool = true
    @State var isUser: Bool = false
    @State var edit: Bool = false
    @Binding var user: [User]
    @State var showEditProfile = false
    @State private var image : UIImage? = nil
    @ObservedObject var userData: UserData
     @ObservedObject var viewRouter: ViewRouter
    @Environment(\.presentationMode) var presentationMode
     var body: some View {
        GeometryReader { geo in
             ZStack {
          
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                    .onAppear() {
                       self.loadData(){userData in
                           self.user = userData
                        hasLoaded = true
                       
                       }
                   }

                 ScrollView {
                 VStack {
                 
                    HStack {
                        Spacer()
                        Text("Edit Profile")
                            .font(.custom("Montserrat", size: 18))
                        Image(systemName: "pencil.circle.fill")
                    }
                    .onTapGesture {
                        showEditProfile = true
                    }
                    .foregroundColor(Color("Primary"))
                    .padding(.top, 10)
                    
                     ProfileRingView(size: geo.size.width-100, userData: userData)

                    Text(userData.name)
                        // .frame(minWidth: 100, alignment: .leading)
                         .font(.custom("Montserrat-Semibold", size: 22))
                         .foregroundColor(Color("Text"))
                         .multilineTextAlignment(.leading)
                        .padding(.vertical, 15)
                    
                    Divider()
                        .foregroundColor(Color("Primary"))
                    
                     HStack {
                       
                      //  ProfileStats(allNum: 0, all: true)
                       // ProfileStats(monthNum: 0, month: true)
                        //ProfileStats(dayNum: 0, day: true)
                       
                     }
                     .padding(.bottom, 15)
                     .padding(.top, 40)
                    
                    Text(userData.description)
                         .frame(minWidth: 100, alignment: .center)
                         .font(.custom("Montserrat-Semibold", size: 18))
                         .foregroundColor(Color("Text"))
                         .multilineTextAlignment(.center)
                        .padding(.bottom, 22)
                    
                   Spacer(minLength: 140)
                 }
                 .padding(.horizontal)
                
             } .sheet(isPresented: self.$showEditProfile){
                EditProfile(profileImage: $profileImage, user: $user, userData: userData)
                    .environmentObject(UserData.shared)
             }
        }
     }
     }

    func sendData() {
       
                let db = Firestore.firestore()
                let ref = db.collection("users")
        let query = ref.whereField("firebaseID", isEqualTo: userData.userID)
            query.getDocuments{snapshot, error in
                if let error = error {
                          print("Error getting documents: \(error)")
                      } else {
                    if snapshot!.documents.count > 1{
                        fatalError("Error, multiple user with the same ID exists.")
                    }
                    for document in snapshot!.documents{
                        for user in user {
                        
                        self.userData.userID = document["id"] as! String
                        self.userData.name = document["name"] as! String
                            db.collection("users").document(userData.userID).updateData([
                                "description":  self.userData.description
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                }
                            }
                        self.userData.description = document["description"] as! String
                    }
                    }
                
            }
               
            }
            
        }
        

    func loadData(performAction: @escaping ([User]) -> Void) {
        let db = Firestore.firestore()
     let docRef = db.collection("users").document(self.userData.userID)
        var userList:[User] = []
        //Get every single document under collection users
    
     docRef.getDocument{ (document, error) in
         
                let result = Result {
                 try document?.data(as: User.self)
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
                
              
            
              performAction(userList)
        }
    }
   
   

 }
    extension UIImage {
        func upload(with folder: String, completion: @escaping (URL?) -> Void) {
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"

            //let fileName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
            let data = self.jpegData(compressionQuality: 0.4)!
            let storage = Storage.storage().reference()
            storage.child(folder).putData(data, metadata: metadata) { meta, error in
                if let error = error {
                    print(error)
                    completion(nil)
                    return
                }

                storage.child(folder).downloadURL { url, error in
                    if let error = error {
                        // Handle any errors
                        print(error)
                        completion(nil)
                    }
                    else {
                        completion(url)
                    }
                }
            }
        }
    }
