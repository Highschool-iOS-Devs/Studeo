//
//  DevChatBanner.swift
//  StudyHub
//
//  Created by Andreas on 12/21/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct DevChatBanner: View {
    @EnvironmentObject var viewRouter:ViewRouter
    var body: some View {
        ZStack {
            Color("Primary")
                .ignoresSafeArea()
                .frame(height: 200)
            HStack {
                VStack {
                Text("Have a question or feedback?")
                    .font(.custom("Montserrat-Bold", size: 18))
                    .foregroundColor(.white)
                    .padding()
                    Button(action: {
                        viewRouter.currentView = .devChat
                    }) {
                        Text("Talk directly to a developer of this app")
                            .font(.custom("Montserrat-Semibold", size: 12))
                            .foregroundColor(Color("Primary"))
                            .padding()
                            .background(RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).foregroundColor(.white))
                    }
                    .padding()
                    
                    }
               
            }
        }
    }
}

struct DevChatBanner_Previews: PreviewProvider {
    static var previews: some View {
        DevChatBanner()
    }
}
