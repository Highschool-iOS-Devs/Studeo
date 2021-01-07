//
//  FullImageView.swift
//  StudyHub
//
//  Created by Andreas on 1/7/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseStorage
struct FullImageView: View {
    @Binding var id: String
    @Binding var viewImage: Bool
    @State private var image : UIImage? = nil
    var body: some View {
        ZStack {
            Color("Background")
                .onAppear() {
                    getProfileImage()
                }
            if image != nil {
            Image(uiImage: image!)
            .resizable()
            .scaledToFit()
            }
            VStack {
                HStack {
                Button(action: {
                    viewImage = false
                }) {
                    Image(systemName: "xmark")
                }
                Spacer()
            }
                Spacer()
            } .padding()
    }
    }
    func getProfileImage() {
      

        // Create a storage reference from our storage service
        
            
      
        let storage = Storage.storage().reference().child("Message_Assets/\(id)")
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        storage.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
           print(error)
          } else {
            // Data for "images/island.jpg" is returned
            withAnimation(.easeInOut) {
            image = UIImage(data: data!)!
                
            }
          }
        }
    }
}


