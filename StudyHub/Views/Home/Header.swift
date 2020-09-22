//
//  Header.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Header: View {
     @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @Binding var showTimer: Bool
    var body: some View {
        HStack {
            VStack {
                Text("Hello,")
                    .frame(minWidth: 150, alignment: .leading)
                    .font(.custom("Montserrat-Regular", size: 16))
                    .foregroundColor(Color(.black))
                    .opacity(25)
                    .multilineTextAlignment(.leading)
                
                Text("\(userData.name)")
                    .frame(minWidth: 150, alignment: .leading)
                    .font(.custom("Montserrat-Semibold", size: 27))
                    .foregroundColor(Color(.black))
                    .multilineTextAlignment(.leading)
            }
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                
                Image("demoprofile")
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5))
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        viewRouter.currentView = .profile
                    })
            } .padding(.trailing, 22)
            
            Button(action: { self.showTimer = true }) {
                ZStack {
                    Color(.white)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    Image("clock")
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 25, height: 25)
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                    
                }
            }
            
        } .padding(.horizontal, 12)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(showTimer: .constant(true))
    }
}
