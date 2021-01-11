//
//  ProfilePics.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseStorage
struct ProfilePic: View {
    var name: String
   // var size: CGFloat
    @State var isTimer = false
    var id = ""
    @State var size = 75
    @State var image = UIImage()
    @State var animate = false
    
    var body: some View {
        ZStack {
            Color.clear
                .onAppear() {
                    getProfileImage()
                }
            if animate {
            if !isTimer {
                VStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: CGFloat(size), height: CGFloat(size))
                    
                        
                        
                        //.frame(width:size,height:size)
                        .clipShape(Circle())
                        
                        .overlay(
                            Circle()
                                
                                .stroke(LinearGradient(gradient: Gradient(colors: [Color("Secondary"), Color("Primary")]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                                .frame(width: CGFloat(size), height: CGFloat(size))
                            
                        )
                    Text(name)
                }
            } else {
                
            }
            }
            }
        }
    
    func getProfileImage() {
      

        // Create a storage reference from our storage service
        
            
      
        let storage = Storage.storage().reference().child("User_Profile/\(id)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storage.getData(maxSize: 1 * 10240 * 10240) { data, error in
          if let error = error {
           print(error)
          } else {
            // Data for "images/island.jpg" is returned
            withAnimation(.easeInOut) {
                if let safeData = data{
                    image = UIImage(data: safeData)! 
                }
                animate = true

       
            }
          }
        }
    }
}

//struct ProfilePic_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePic()
//    }
//}
