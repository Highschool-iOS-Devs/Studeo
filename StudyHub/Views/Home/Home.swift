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
     @EnvironmentObject var viewRouter:ViewRouter
    @State private var search: String = ""
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                Header()
                SearchBar()
                Spacer()
                HStack {
                    
                    Text("Start here!")
                        .frame(minWidth: 100, alignment: .leading)
                        .font(.custom("Montserrat-Semibold", size: 18))
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                } .padding(.horizontal, 12)
                
                CTA(imgName: "friends", cta: "Add Friends")
                
                CTA(imgName: "Group", cta: "Add Group")
                
                 CTA(imgName: "study", cta: "Compete")
                Spacer()
                
            }
        } .padding(.bottom, 85)
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
