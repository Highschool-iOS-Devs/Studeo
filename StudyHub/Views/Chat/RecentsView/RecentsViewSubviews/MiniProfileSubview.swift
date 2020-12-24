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
                         print("success: \(r)")
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
        
        .frame(width:70, height: 40)
        .padding()
        .onAppear{
            getProfileImage()
        }
    }
    func getProfileImage(){
        for member in group.members{
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            let storage = Storage.storage().reference().child("User_Profile/\(member)")
            storage.downloadURL{url, error in
                if let error = error{
                    print("Error downloading image, \(error)")
                }
                profileImages.append(url ?? URL(string: "https://firebasestorage.googleapis.com/v0/b/study-hub-7540b.appspot.com/o/User_Profile%2F632803C1-F7B2-44C0-86A6-C589F17DEE97?alt=media&token=18198a24-b65e-4209-8c77-1f78ac6e6925")!)
            }
        }
       
    }
}

