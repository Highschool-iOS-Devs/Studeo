//
//  MiniProfileSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
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

struct MiniProfileSubview: View {
    @State var profileImages:[URL] = []
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    var group:Groups
    var body: some View {
        LazyVGrid(columns: gridItemLayout){
            ForEach(0..<profileImages.count, id: \.self){index in
                KFImage(profileImages[index], options: [.transition(.fade(0.5)), .processor(DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))), .cacheOriginalImage])
                    .onSuccess { r in
                         // r: RetrieveImageResult
                         //print("success: \(r)")
                     }
                     .onFailure { e in
                         // e: KingfisherError
                         print("failure: \(e)")
                     }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(minWidth:10, minHeight:10)
                    .overlay(Circle().stroke(Color("Background"), lineWidth: 1))
                    .animation(.easeInOut)
                    .transition(.opacity)

            }
        } .animation(.easeInOut)
        .transition(.opacity)
        
        .frame(width:25, height: 25)
        .padding()
        .onAppear{
            getProfileImage()
        }
    }
    func getProfileImage(){
        if profileImages == []{
            for member in group.members{
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpeg"
                let storage = Storage.storage().reference().child("User_Profile/\(member)")
                storage.downloadURL{url, error in
                    if let error = error{
                        print("Error downloading image, \(error)")
                    }
                    profileImages.append(url!)
                }
            }
        }
    
       
    }
}

