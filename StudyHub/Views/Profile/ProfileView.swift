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
    @State var imagePicker: Bool = false
    @Binding var profileImage: UIImage
    @State var hasLoaded: Bool = true
    @State var isUser: Bool = false
    @State var edit: Bool = false
    @Binding var user: [User]
    @State var showLoadingAnimation = false
    @State private var showImagePicker : Bool = false
       @State private var image : UIImage? = nil
    @EnvironmentObject var userData: UserData
    @Environment(\.presentationMode) var presentationMode
     var body: some View {
         ZStack {
            if !showImagePicker {
                Color(.systemBackground)
                   .onAppear() {
                     // profileImage = UIImage(named: "5539")
                   
                   
                    //  downloadImage()
                      
                   }
            }
            if isUser {
                Color(.systemBackground)
                    .onAppear() {
                      // profileImage = UIImage(named: "5539")
                        //downloadImage()
                        
                    }
             
                
                
            if hasLoaded {
                if !showLoadingAnimation {
                   
             ScrollView(showsIndicators: false) {
             VStack {
                 Spacer()
                HStack {
                    Spacer()
                   
                    Image(uiImage: (profileImage))
                       
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5))
                        
                        .frame(width: 150, height: 150, alignment: .center)
                        .onTapGesture{
                            showImagePicker.toggle()
                         }
                    Spacer()
                    
                } .padding(.horizontal, 42)
                
                    
                

                Text(userData.name)
                    // .frame(minWidth: 100, alignment: .leading)
                     .font(.custom("Montserrat-Semibold", size: 22))
                     .foregroundColor(Color(.black))
                     .multilineTextAlignment(.center)
                    
                    Spacer()
                 HStack {
                    ForEach(user){ user in
                        ProfileStats(allNum: user.all, all: true)
                        ProfileStats(monthNum: user.month, month: true)
                        ProfileStats(dayNum: user.day, day: true)
                   
                    }
                   
                 }
                Text(userData.description)
                     .frame(minWidth: 100, alignment: .leading)
                     .font(.custom("Montserrat-Semibold", size: 18))
                     .foregroundColor(Color(.black))
                     .multilineTextAlignment(.center)
                   
                     .padding()
                    .onTapGesture() {
                        showImagePicker = true
                    }
             }
                
             }
                    
            
             .sheet(isPresented: self.$showImagePicker){
                ImagePicker(isShown: self.$showImagePicker, image: self.$image, userID: $userData.userID)
                    .environmentObject(userData)
             }
                
                }
                    
            }
                Spacer(minLength: 110)
                
                
            } else {
                Color(.systemBackground)
                   .onAppear() {
                     // profileImage = UIImage(named: "5539")
                      //downloadImage()
                       self.loadData(){userData in
                           //Get completion handler data results from loadData function and set it as the recentPeople local variable
                           self.user = userData
                        hasLoaded = true
                       
                       }
                   }
                //if hasLoaded {
                    ForEach(user){ user in
                 ScrollView(showsIndicators: false) {
                 VStack {
                 
                    HStack {
                        
                        Spacer()
                       
                        Image(uiImage: (profileImage))
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5))
                            .frame(width: 300, height: 300, alignment: .center)
                           
                           
                        Spacer()
                        
                    }
                 
                    .onTapGesture {
                      //  showImagePicker = true
                     }
                    .sheet(isPresented: self.$showImagePicker){
                        ImagePicker(isShown: self.$showImagePicker, image: self.$image, userID: $userData.userID)
                            .environmentObject(userData)
                     }
                    .padding(.horizontal, 42)
                     

                    Text(user.name)
                        // .frame(minWidth: 100, alignment: .leading)
                         .font(.custom("Montserrat-Semibold", size: 22))
                         .foregroundColor(Color(.black))
                         .multilineTextAlignment(.leading)
                        .padding(.bottom, 22)
                       
                     HStack {
                       
                        ProfileStats(allNum: user.all, all: true)
                        ProfileStats(monthNum: user.month, month: true)
                        ProfileStats(dayNum: user.day, day: true)
                       
                      
                       
                     }  .padding(.bottom, 22)
                    Text(user.description)
                         .frame(minWidth: 100, alignment: .center)
                         .font(.custom("Montserrat-Semibold", size: 18))
                         .foregroundColor(Color(.black))
                         .multilineTextAlignment(.center)
                         .padding()
                        .padding(.bottom, 22)
                    Spacer(minLength: 110)
                 }
                 }

                
           //     }
                    }
                if !isUser {
                    VStack {
                        
                        HStack {
                            Spacer()
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.black)
                                .font(.title)
                                .onTapGesture {
                                    edit.toggle()
                                }
                            
                        }
                        Spacer()
                    } .padding()
                    .sheet(isPresented: $edit) {
                        EditProfile(profileImage: $profileImage, user: $user)
                            .environmentObject(userData)
                    }
                }
                
                if showLoadingAnimation {
                    BlurView(style: .systemChromeMaterial)
                        .edgesIgnoringSafeArea(.all)
                    VStack{
                        LottieUIView()
                            .animation(.easeInOut)
                        Text("Loading...")
                            .font(.custom("Montserrat-SemiBold", size: 25))
                            .offset(y: -40)
                    }
                    .frame(width: 300, height: 400)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                   // .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                    .animation(.easeInOut)
                  
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
