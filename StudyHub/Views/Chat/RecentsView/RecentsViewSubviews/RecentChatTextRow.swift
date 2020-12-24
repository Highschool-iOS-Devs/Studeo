//
//  RecentChatTextRow.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/15/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct RecentChatTextRow: View {
    @Binding var add:Bool
    var body: some View {
        HStack {
            VStack {
                Text("Recent Chats").font(.custom("Montserrat Bold", size: 24)).foregroundColor(Color("Primary"))
            }
            Spacer()
            Text("View all").font(.custom("Montserrat Regular", size: 15)).foregroundColor(Color("Primary"))
                .padding(.trailing, 5)
            
            Circle()
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: "plus")
                        .foregroundColor(Color("Primary"))
                        .font(.system(size: 14, weight:.bold))
                        .onTapGesture {
                            add = true
                        }
                )
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.20000000298023224)), radius: 4, x: 0, y: 2)
        }
        .padding(.horizontal, 20)
        .padding(.top, 80)
        .padding(.bottom, 30)
    }
}

