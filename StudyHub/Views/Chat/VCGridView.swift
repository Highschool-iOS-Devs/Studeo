//
//  VCGridView.swift
//  StudyHub
//
//  Created by Andreas on 1/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor
import struct Kingfisher.ImageResource
import class Kingfisher.ImageCache
import AgoraRtcKit

struct VCGridView: View {
    @State var profileImages:[URL] = []
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var users: [User]
    @Binding var isMuted: Bool
    @Binding var agoraKit: AgoraRtcEngineKit
   
    var body: some View {
        LazyVGrid(columns: gridItemLayout){
            ForEach(users, id: \.self){ user in
                KFImage(user.profileImageURL, options: [.transition(.fade(0.5)), .processor(DownsamplingImageProcessor(size: CGSize(width: 500, height: 500))), .cacheOriginalImage])
                    .onSuccess { r in
                         // r: RetrieveImageResult
                         //print("success: \(r)")
                     }
                     .onFailure { e in
                         // e: KingfisherError
                         print("failure: \(e)")
                     }
                    .resizable()
                    .id(UUID())
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(minWidth:100, minHeight:100)
                    .overlay(Circle().stroke(Color("Background"), lineWidth: 1))
                    .animation(.easeInOut)
                    .transition(.opacity)
                    
            }
           
          
        } .animation(.easeInOut)
        .transition(.opacity)
        
       
        .padding()
        .onAppear{
            getProfileImage()
        }
        .onChange(of: users, perform: { value in
            getProfileImage()
        })
        
    }
    func getProfileImage(){
        if profileImages == []{
            for i in users.indices {
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                let storage = Storage.storage().reference().child("User_Profile/\(users[i].id)")
                storage.downloadURL{url, error in
                    if let error = error{
                        print("Error downloading image, \(error)")
                    }
                    users[i].profileImageURL = url
                }
            }
        }
    
       
    }
}

