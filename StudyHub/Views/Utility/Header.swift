//
//  Header.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Header: View {
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter:ViewRouter
    @Binding var showTimer: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                HStack {
                    Text("Hello,")
                        .font(Font.custom("Montserrat-Regular", size: 17, relativeTo: .headline))
                        .foregroundColor(Color("Text"))
                        .opacity(25)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                HStack {
                    Text("\(userData.name)")
                        .frame(minWidth: 150, alignment: .leading)
                        .font(Font.custom("Montserrat-SemiBold", size: 22, relativeTo: .title))
                        .foregroundColor(Color("Text"))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
            } .padding(.horizontal)
            Spacer()
            
            Button(action: {viewRouter.currentView = .profile}) {
                
                ProfileRingView(size: 55, userData: userData)
                
            } .padding(.trailing, 22)
            
            //            Button(action: { withAnimation(.easeInOut(duration: 0.5)) {
            //                    self.showTimer = true }}) {
            //                ZStack {
            //                    Color.white
            //                        .frame(width: 40, height: 40)
            //                        .clipShape(Circle())
            //                        .shadow(color: Color.black.opacity(0.1), radius: 3)
            //                        .overlay(
            //                            Image(systemName: "timer")
            //                                .foregroundColor(.black)
            //                                .font(.system(size: 20)))
            //
            //                }
            //            }
            
        }
        .frame(height: 90)
        
        .padding(.top)
        .background(BlurView(style: .systemMaterial))
        .border(Color("Background").opacity(0.3), width:0.5)
        .edgesIgnoringSafeArea(.all)
        
        
        
        
    }
}


