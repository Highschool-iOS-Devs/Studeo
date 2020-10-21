//
//  ProfilePics.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ProfilePic: View {
    var body: some View {
        ZStack {
            VStack {
            Image("demoprofile")
                .resizable()
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                            Circle()
                                .stroke(LinearGradient(gradient: Gradient(colors: [Color("barCenter"), Color("aqua")]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 10)
                        )
               Text("Andreas")
                .font(.headline)
            }
        } .padding()
    }
}
