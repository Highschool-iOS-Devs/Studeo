//
//  RecentChatGroupSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct RecentChatGroupSubview: View {
    @State var group:Groups

    var body: some View {
   
        ZStack {
   
            VStack{
                Text(group.groupName)
                        .font(.custom("Montserrat Bold", size: 20))
                        .minimumScaleFactor(0.1)

                    .foregroundColor(Color.white.opacity(0.96))
                        .multilineTextAlignment(.center)
                        .padding(.bottom,2)
                    //5 members
                
                Text("\(group.members.count) members").font(.custom("Montserrat SemiBold", size: 15)).foregroundColor(Color.white.opacity(0.96)).multilineTextAlignment(.center)
                //Available in iOS 14 only
                .textCase(.uppercase)
                //SAT
              
            }
            .padding(.bottom, 40)
        
     
    }
        .frame(width: 138, height: 138)
        .background(Color("GroupCard"))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color("CardShadow"), radius:3, x:0, y:0)
      
    }
}

//struct RecentChatGroupSubview_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentChatGroupSubview(group: Groups)
//    }
//}
