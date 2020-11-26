//
//  ProfilePics.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ProfilePic: View {
    var name: String
    var size: CGFloat
    var body: some View {
        ZStack {
            VStack {
            Image("demoprofile")
                .resizable()
                .frame(width:size,height:size)
                .clipShape(Circle())
                .overlay(
                            Circle()
                                .stroke(LinearGradient(gradient: Gradient(colors: [Color("barCenter"), Color("aqua")]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                        )
             Text(name)
            }
        } .padding()
    }
}

//struct ProfilePic_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfilePic()
//    }
//}
