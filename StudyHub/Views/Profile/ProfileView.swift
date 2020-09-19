//
//  ProfileView.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/19/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import UIKit
 struct ProfileView: View {
    @State var imagePicker: Bool = false
    @State var profileImage = UIImage(named: "5539")
     var body: some View {
         ZStack {
             Color(.systemBackground)
             ScrollView(showsIndicators: false) {
             VStack {
                 Spacer()
                 HStack {
                     Spacer()
                 Image("demoprofile")
                     .renderingMode(.original)
                     .resizable()
                     .aspectRatio(contentMode: .fit)
                     .clipShape(Circle())
                     .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5))
                     .padding(.top, 42)
                     Spacer()
                 } .padding(.horizontal, 42)
                 .onTapGesture{
                    imagePicker.toggle()
                 } .onAppear() {
                    profileImage = UIImage(named: "5539")
                    uploadImage()
                 }
                 Spacer()

                 Text("Andreas Ink")
                     .frame(minWidth: 100, alignment: .leading)
                     .font(.custom("Montserrat-Semibold", size: 22))
                     .foregroundColor(Color(.black))
                     .multilineTextAlignment(.leading)
                    Spacer()
                 HStack {
                     Spacer()
                 Text("\(Int(0))")
                     .font(.custom("Montserrat-SemiBold", size: 12))
                     .foregroundColor(Color.black.opacity(0.25))
                 Image(systemName: "stopwatch.fill")
                     .foregroundColor(Color.black.opacity(0.25))
                     .offset(x: 0, y: -2)
                     Spacer()
                     Text("\(Int(0))")
                         .font(.custom("Montserrat-SemiBold", size: 12))
                         .foregroundColor(Color.black.opacity(0.25))
                     Image(systemName: "stopwatch.fill")
                         .foregroundColor(Color.black.opacity(0.25))
                         .offset(x: 0, y: -2)
                     Spacer()
                     Text("\(Int(0))")
                         .font(.custom("Montserrat-SemiBold", size: 12))
                         .foregroundColor(Color.black.opacity(0.25))
                     Image(systemName: "stopwatch.fill")
                         .foregroundColor(Color.black.opacity(0.25))
                         .offset(x: 0, y: -2)
                     Spacer()
                 }
                 Text("Lorem ipsum dolor sit amet, te his quot quas conclusionemque. Audire accusata quo id, pri ex platonem postulant. Simul eripuit duo ex, ex saepe mucius eam, quem brute mucius vix ei. Sed eu etiam error detraxit, cum ad natum tincidunt mnesarchum. Etiam convenire cum in, graeci conceptam mea at, eum illud accumsan offendit ei. Est et congue appellantur. Id sed homero senserit, alii ponderum quaestio cu quo.")
                     .frame(minWidth: 100, alignment: .leading)
                     .font(.custom("Montserrat-Semibold", size: 18))
                     .foregroundColor(Color(.black))
                     .multilineTextAlignment(.leading)
                     .padding()
             }
             }
            if imagePicker {
               // ImagePicker(selectedImage: $profileImage)
            }
         }
     }
    func uploadImage() {
   
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let storage = Storage.storage().reference()
        storage.child("images").putData(profileImage!.jpegData(compressionQuality: 0.4)!, metadata: metadata) { meta, error in
            if let error = error {
                print(error)
                return
            }

           
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
