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
    @Binding var profileImage: UIImage?
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
    var imagePlaceholder = Image(systemName: "person.circle.fill")

    var body: some View {
        ZStack {
            ScrollView(/*@START_MENU_TOKEN@*/.vertical/*@END_MENU_TOKEN@*/, showsIndicators: false) {
        ForEach(user){ user in
     VStack {
         Spacer()
        HStack {
            
            Spacer()
            if profileImage == nil{
                ZStack(alignment:.center) {
                    imagePlaceholder
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 350, height: 350)
                        .overlay(BlurView(style: .systemThinMaterial))
                        .clipShape(Circle())
                        .overlay(
                                Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5)
                        )
                    Text("Tap to choose")
                        .font(.custom("Montserrat-Bold", size: 30))
                        .foregroundColor(Color("Primary"))
                }
                
            }
            else{
                Image(uiImage: (profileImage!))
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 350)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5))
                    .padding(.top, 110)
                    .padding(.bottom, 22)
            }
         
               

            
        }
        .onTapGesture {
            showImagePicker = true
         }
        .sheet(isPresented: self.$showImagePicker){
            ImagePicker(isShown: self.$showImagePicker, image: self.$image, userID: $userData.userID)
                .environmentObject(userData)
                .onDisappear() {
                    profileImage = image ?? profileImage
                    self.userData.profilePictureURL = nil
                }
         }
        .padding(.horizontal, 42)


        TextField(user.name, text: $name)
            
             .font(.custom("Montserrat-Semibold", size: 22))
             .foregroundColor(Color(.black))
             .multilineTextAlignment(.leading)
            .padding(.bottom, 22)
            .padding()

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
            .padding(.horizontal, 22)
        Button(action: {
            sendData()
            uploadImage()
            
    
        }) {
            Text("Save")
                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
        }
        .buttonStyle(BlueStyle())
        .padding()
        .padding(.horizontal, 22)
        Spacer()
        
     }
     
     }
     .padding(.horizontal)

      
        }
    }
}

    func uploadImage() {
      
           let metadata = StorageMetadata()
           metadata.contentType = "image/jpeg"
        let storage = Storage.storage().reference().child("User_Profile/\(userData.userID)")
        if let image = profileImage{
            storage.putData(image.jpegData(compressionQuality: 0.01)!, metadata: metadata) { meta, error in
               if let error = error {
                   print(error)
                   return
               }

              
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
            
