//
//  Home.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var userData: UserData
    @State private var search: String = ""
    var body: some View {
        VStack {
            ScrollView {
                Header()
                ZStack {
                    HStack {
                        Spacer()
                        Divider()
                            .frame(height: 25)
                        Image("dropdown")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .aspectRatio(contentMode: .fit)
                    } .padding(.horizontal, 44)
                    TextField("Search", text: $search)
                        .font(Font.custom("Montserrat-Regular", size: 15.0))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10.0)
                    
                } .padding(.horizontal, 22)
                    .padding(.vertical, 22)
                Spacer()
                HStack {
                    
                    Text("Start here!")
                        .frame(minWidth: 100, alignment: .leading)
                        .font(.custom("Montserrat-Semibold", size: 18))
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                } .padding(.horizontal, 12)
                
                ZStack {
                    Image("friends")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 300, height: 300)
                        .padding(.horizontal, 12)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                Text("Add Friends")
                                    .foregroundColor(.white)
                                    .padding() .background(Color("blue"))
                                    .cornerRadius(10)
                                
                                
                                
                            }
                        }
                    } .padding(.all, 22)
                }
                Spacer()
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
