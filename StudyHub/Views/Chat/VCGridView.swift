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
//import AgoraRtcKit

struct VCGridView: View {
    @State var profileImages:[URL] = []
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]
    @Binding var users: [User]
    @Binding var isMuted: Bool
    //@Binding var agoraKit: AgoraRtcEngineKit
   
    var body: some View {
        ZStack {
            Color.clear
                .onAppear() {
                    users = users.removeDuplicates()
                }
        VStack {
            Spacer()
            ForEach(users, id: \.id.uuidString){ user in
                ProfilePic(name: "", id: user.id.uuidString)
                    .id(user.firebaseID)
                    .aspectRatio(contentMode: .fill)
                    .clipShape(Circle())
                    .frame(maxWidth:75, maxHeight:75)
                    .overlay(Circle().stroke(Color("Background"), lineWidth: 1))
                    .animation(.easeInOut)
                    .transition(.opacity)
                    
            }
           
          
        } .animation(.easeInOut)
        .transition(.opacity)
        
       
        .padding()
        .onAppear{
           // getProfileImage()
        }
        .onChange(of: users, perform: { value in
           // getProfileImage()
        })
        
    }
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

