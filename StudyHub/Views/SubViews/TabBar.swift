//
//  TabBar.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TabBar: View {
    @State var currentSelected = "Chat"
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                tabItemView(SFImage: "message.fill", text: "Chat")
                tabItemView(SFImage: "book.fill", text: "Books")
                    .padding(.trailing, 30)
                tabItemView(SFImage: "person.2.fill", text: "Groups")
                    .padding(.leading, 30)
                tabItemView(SFImage: "gear", text: "Settings")
    
            }
            .frame(width: screenSize.width, height: screenSize.height/10)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .background(Color.white.shadow(radius: 2))
        .overlay(
            
            ZStack {
                Circle()
                    .fill(Color("Secondary"))
                    .frame(width: 70, height: 70)
                Image(systemName: "house.fill")
                    .frame(alignment: .center)
                    .foregroundColor(.white)
                    .font(.system(size: 28))
            }
        .offset(x: 0, y: -30)
            )
        
            
           
        }.edgesIgnoringSafeArea(.all)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

struct tabItemView: View {
    var SFImage:String
    var text:String
    var body: some View {
        VStack {
            Image(systemName: SFImage)
                .font(.system(size: 20))
                .padding(.bottom, 5)
            
            Text(text)
                .font(.custom("Montserrat-Bold", size: 10))
            
        }
        .frame(width:60)
        .foregroundColor(Color.black.opacity(0.25))
        .padding(.top, 15)
        
    }
}
 
