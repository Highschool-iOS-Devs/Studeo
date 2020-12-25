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
    @State var tapped:Bool = false

    var body: some View {
   
        ZStack {
   
            VStack{
                Text(group.groupName)
                        .font(.custom("Montserrat Bold", size: 20))
                        .minimumScaleFactor(0.1)

                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .multilineTextAlignment(.center)
                        .padding(.bottom,2)
                    //5 members
                
                Text("\(group.members.count) members").font(.custom("Montserrat SemiBold", size: 15)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                //Available in iOS 14 only
                .textCase(.uppercase)
                //SAT
              
            }
            .padding(.bottom, 40)
        
     
    }
        .frame(width: 138, height: 138)
        .background(Color(#colorLiteral(red: 0.27450981736183167, green: 0.886274516582489, blue: 0.9803921580314636, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color(#colorLiteral(red: 0.27450981736183167, green: 0.886274516582489, blue: 0.9803921580314636, alpha: 0.30000001192092896)), radius:7, x:4, y:4)
        .onTapGesture{
            tapped = true
        }
      
    }
}

//struct RecentChatGroupSubview_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentChatGroupSubview(group: Groups)
//    }
//}
