//
//  GroupsView.swift
//  StudyHub
//
//  Created by Santiago Quihui on 29/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct GroupsView: View {
    @State private var search = ""
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Header()
                TextField("Search Groups", text: self.$search)
                    .textFieldStyle(SearchTextField())
                HStack {
                    Text("My Groups")
                        .font(.custom("Montserrat-Semibold", size: 18))
                    Spacer()
                } .padding(.horizontal, geometry.size.width * 0.15)
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(0 ..< 3) { _ in
                        VStack {
                            Image("finance")
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
                                .padding(.horizontal, 12)
                            
                            
                            HStack {
                                Spacer()
                                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                    Text("Finances")
                                        .font(Font.custom("Montserrat-SemiBold", size: 16))
                                }
                                .buttonStyle(BlueStyle())
                                .frame(width: 150)
                            }
                            
                            
                        }
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.gray.opacity(0.7), lineWidth: 2)
                        )
                            .padding(.horizontal, geometry.size.width * 0.15)
                            .padding(.bottom, 10)
                    }
                }
            }
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
