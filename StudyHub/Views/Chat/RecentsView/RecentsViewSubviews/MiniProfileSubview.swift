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
            ForEach(group.members, id: \.self){ user in
                ProfilePic(name: "", id: user, size: 10)
                   
                   
                    .overlay(Circle().stroke(Color("Background"), lineWidth: 1))
                    .animation(.easeInOut)
                    .transition(.opacity)

            }
        } .animation(.easeInOut)
        .transition(.opacity)
        
        .frame(width:25, height: 25)
        .padding()
        
    }

}

