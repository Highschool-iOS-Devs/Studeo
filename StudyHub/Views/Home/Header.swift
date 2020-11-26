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
                HStack {
                Text("Hello,")
                    .font(.custom("Montserrat-Regular", size: 16))
                    .foregroundColor(Color(.black))
                    .opacity(25)
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack {
                Text("\(userData.name)")
                    .frame(minWidth: 150, alignment: .leading)
                    .font(.custom("Montserrat-Semibold", size: 27))
                    .foregroundColor(Color(.black))
                    .multilineTextAlignment(.leading)
                    Spacer()
                }
            } .padding(.horizontal)
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                
                Image("demoprofile")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
                    .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                        viewRouter.currentView = .profile
                    })
            } .padding(.trailing, 22)
            
            Button(action: { self.showTimer = true }) {
                ZStack {
                    Color.white
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 3)
                        .overlay(
                            Image(systemName: "timer")
                                .foregroundColor(.black)
                                .font(.system(size: 20)))
                    
                }
            }
            
        }.padding(.horizontal, 15)
        .padding(.top, 10)
    }
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        Header(showTimer: .constant(true))
    }
}
