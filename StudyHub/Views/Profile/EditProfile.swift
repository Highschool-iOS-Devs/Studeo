//
//  EditProfile.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseStorage
struct EditProfile: View {
    @State var imagePicker: Bool = false
    @Binding var profileImage: UIImage
    @State var hasLoaded: Bool = false
    @State var isUser: Bool = false
    @State var edit: Bool = false
    @Binding var user: [User]
    @State var showLoadingAnimation = true
    @State private var showImagePicker : Bool = false
    @State var description: String = ""
    @State var name: String = ""
    @EnvironmentObject var userData: UserData
       @State private var image : UIImage? = nil
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
          
        ForEach(user){ user in
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
                .padding(.top, 110)
                .padding(.bottom, 22)
               
            Spacer()
            
        }
        .onTapGesture {
            showImagePicker = true
         }
        .sheet(isPresented: self.$showImagePicker){
            ImagePicker(isShown: self.$showImagePicker, image: self.$image, userID: $userData.userID)
                .environmentObject(userData)
         }
        .padding(.horizontal, 42)
         Spacer()

        TextField(user.name, text: $name)
            
             .font(.custom("Montserrat-Semibold", size: 22))
             .foregroundColor(Color(.black))
             .multilineTextAlignment(.leading)
            .padding(.bottom, 22)
            .padding()
            Spacer()
         HStack {
           
            ProfileStats(allNum: user.all, all: true)
            ProfileStats(monthNum: user.month, month: true)
            ProfileStats(dayNum: user.day, day: true)
           
          
           
         }  .padding(.bottom, 22)
     
        TextField(user.description, text: $description)
             .frame(minWidth: 100, alignment: .leading)
             .font(.custom("Montserrat-Semibold", size: 18))
             .foregroundColor(Color(.black))
             .multilineTextAlignment(.center)
             .padding()
            .padding(.bottom, 22)
        
        Button(action: {
         sendData()
            uploadImage()
            
    
        }) {
            Text("Save")
                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
        }
        .buttonStyle(BlueStyle())
        .padding()
        Spacer(minLength: 110)
        
        
     
     }
        }
    
//     }
      
        }
    }
}
    func uploadImage() {
      
           let metadata = StorageMetadata()
           metadata.contentType = "image/jpeg"

           let storage = Storage.storage().reference()
        storage.child(userData.userID).putData(profileImage.jpegData(compressionQuality: 0.4)!, metadata: metadata) { meta, error in
               if let error = error {
                   print(error)
                   return
               }

              
           }
          
     
   }
    func sendData() {
       
                let db = Firestore.firestore()
               
      
       
      
        if name == "" {
            name = userData.name
        }
        if description == "" {
            description = userData.description
        }
                      
                            db.collection("users").document(userData.userID).updateData([
                                "description":  self.description,
                                "name":  self.name
                            ]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    print("Document successfully updated")
                                    
                                    self.userData.description = self.description
                                        self.userData.name = self.name
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }
                           
                    
            }
               
            }
            
