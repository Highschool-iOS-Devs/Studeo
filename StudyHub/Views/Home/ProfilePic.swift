//
//  ProfilePics.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ProfilePic: View {
    @State var name: String = ""
    var body: some View {
        ZStack {
            VStack {
            Image("demoprofile")
                .resizable()
                .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: 75, maxWidth: 100, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: 75, maxHeight: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                .scaledToFit()
                .clipShape(Circle())
                .overlay(
                            Circle()
                                .stroke(LinearGradient(gradient: Gradient(colors: [Color("barCenter"), Color("aqua")]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                        )
             
            }
        } .padding()
    }
}
