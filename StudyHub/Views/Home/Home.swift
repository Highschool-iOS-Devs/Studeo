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
            Header()
            ZStack {
                HStack {
                    Spacer()
                    Divider()
                        .frame(height: 25)
                    Image("dropdown")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fit)
                } .padding(.horizontal, 44)
                TextField("Search", text: $search)
                    .font(Font.custom("Montserrat-Regular", size: 15.0))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10.0)
                  
            } .padding(.horizontal, 22)
            Spacer()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
