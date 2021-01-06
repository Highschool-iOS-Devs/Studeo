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
import class Kingfisher.KingfisherManager

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
        GeometryReader { geo in
            ZStack {
                
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                
                ForEach(user){ user in
                     VStack {
                        ZStack(alignment:.center) {
                            if profileImage == nil{
                                ProfileRingView(size: geo.size.width-90)
                                    .opacity(0.5)
                            }
                            else{
                                Image(uiImage: profileImage!)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: geo.size.width-90, height: geo.size.width-90)
                                    .clipShape(Circle())
                                    .overlay(
                                            Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5)
                                    )
                                    .opacity(0.5)

            
                            }
                            Text("Tap to choose")
                                .font(.custom("Montserrat-Bold", size: 30))
                                .foregroundColor(Color("Primary"))
                            }
                            .padding(.top, 20)
                            .onTapGesture {
                                showImagePicker = true
                             }
                            .sheet(isPresented: self.$showImagePicker){
                                ImagePicker(isShown: self.$showImagePicker, image: self.$image, userID: $userData.userID)
                                    .environmentObject(userData)
                                    .onDisappear() {
                                        profileImage = image ?? profileImage
                                    }
                             }
                            .padding(.horizontal, 42)

                    VStack(alignment: .center){
                        
                        TextField(user.name, text: $name)
                         .font(.custom("Montserrat-Semibold", size: 22))
                         .foregroundColor(Color("Text"))
                         .multilineTextAlignment(.center)

                         HStack {
                           
                            ProfileStats(allNum: user.all, all: true)
                            ProfileStats(monthNum: user.month, month: true)
                            ProfileStats(dayNum: user.day, day: true)
                           
                          
                           
                         } .padding(.vertical, 22)
                     
                        TextField(user.description, text: $description)
                             .frame(minWidth: 100, alignment: .leading)
                             .font(.custom("Montserrat-Semibold", size: 18))
                             .foregroundColor(Color("Text"))
                             .multilineTextAlignment(.center)
                       
                    }
                    .padding()
                    .padding(.bottom, 22)
                    .padding(.horizontal, 22)
                  
                    Button(action: {
                        sendData()
                        resizeImage()
                        uploadImage()
                        //downloadImages()
                
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
     
        } .frame(width: geo.size.width)
        }
}

    func resizeImage(){
        if var image = profileImage{
            while image.getSizeIn(.megabyte)! >= Double(2){
                image = image.resizeWithPercent(percentage: 0.8)!
            }
            profileImage = image
        }
        
    }
    func uploadImage() {
      
           let metadata = StorageMetadata()
           metadata.contentType = "image/jpeg"
        let storage = Storage.storage().reference().child("User_Profile/\(userData.userID)")
        if let image = profileImage{
        
            storage.putData(image.jpegData(compressionQuality: 100)!, metadata: metadata) { meta, error in
               if let error = error {
                   print(error)
                   return
               }

                KingfisherManager.shared.cache.clearCache()

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
            
extension UIImage {

    public enum DataUnits: String {
        case byte, kilobyte, megabyte, gigabyte
    }

    func getSizeIn(_ type: DataUnits)-> Double? {

        guard let data = self.pngData() else {
            return nil
        }

        var size: Double = 0.0

        switch type {
        case .byte:
            size = Double(data.count)
        case .kilobyte:
            size = Double(data.count) / 1024
        case .megabyte:
            size = Double(data.count) / 1024 / 1024
        case .gigabyte:
            size = Double(data.count) / 1024 / 1024 / 1024
        }

        return size
    }
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
