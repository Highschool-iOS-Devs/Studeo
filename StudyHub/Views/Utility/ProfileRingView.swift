//
//  ProfileRingView.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/18/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import KingfisherSwiftUI

struct ProfileRingView: View {
    var imagePlaceholder = Image(systemName: "person.circle.fill")
    var size:CGFloat
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        if userData.profilePictureURL == nil {
            imagePlaceholder
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
                .onAppear{
                    downloadImages()
                }
        }
        else{
            KFImage(userData.profilePictureURL)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
        }
        
        
    }
    
    func downloadImages(){
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let storage = Storage.storage()
        let pathReference = storage.reference(forURL: "gs://study-hub-7540b.appspot.com/User_Profile/\(userData.userID)")
        pathReference.downloadURL { url, error in
            if let error = error {
                print("Error downloading image, \(error)")
            } else {
                userData.profilePictureURL = url
            }
        }
        
    }
    
}
