//
//  ProfileRingView.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/27/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import KingfisherSwiftUI
import struct Kingfisher.DownsamplingImageProcessor

struct ProfileRingView: View {
    var imagePlaceholder = Image(systemName: "person.circle.fill")
    var size:CGFloat
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        KFImage(URL(string: userData.profilePictureURL), options: [.transition(.fade(0.5)), .processor(DownsamplingImageProcessor(size: CGSize(width: size*3, height: size*3))), .cacheOriginalImage])
            .onSuccess { r in
                 // r: RetrieveImageResult
                 print("success: \(r)")
             }
             .onFailure { e in
                 // e: KingfisherError
                 print("failure: \(e)")
             }
             .placeholder {
                 ProgressView()
             }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: computeLineWidth()))
     
          
    }
    func computeLineWidth() -> CGFloat{
        let lineWidth = 0.046*size
        if lineWidth > 4{
            return 4
        }
        else{
            return lineWidth
        }
    }

  
}


struct ProfileRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRingView(size: 56)
    }
}
