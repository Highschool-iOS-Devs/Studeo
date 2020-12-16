//
//  RecentChatRowSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/27/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct RecentGroupRowSubview: View {
    var group:Groups
    @State var tapped:Bool = false
    var profilePicture:Image
    @EnvironmentObject var userData: UserData
    @State var chat = false
    var body: some View {
        //Chat row background
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
   
            HStack {
                ProfileRingView(image: profilePicture, size: 53)
                VStack {
                //ACT Group
                    Text(group.groupName).font(.custom("Montserrat SemiBold", size: 15)).foregroundColor(Color(#colorLiteral(red: 0, green: 0.6, blue: 1, alpha: 1)))
                            .textCase(.uppercase)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    //The answer is 235
                        Text("Message preview placeholder").font(.custom("Montserrat Regular", size: 12))
                            .foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.57, blue: 0.82, alpha: 1)))
                            .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 20)
                
                VStack {
                    ZStack {
                    //Ellipse 50
                        Circle()
                        .fill(Color(#colorLiteral(red: 0.9666666388511658, green: 0.257515013217926, blue: 0.2497221827507019, alpha: 1)))
                        .frame(width: 16, height: 16)
                        //8
                        Text("8").font(.custom("Montserrat SemiBold", size: 9)).foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))).multilineTextAlignment(.center)
                    //Available in iOS 14 only
                        .textCase(.uppercase)
                    }
                    //4:17 AM
                        Text("4: 17 AM").font(.custom("Montserrat Regular", size: 12)).foregroundColor(Color(#colorLiteral(red: 0.18, green: 0.57, blue: 0.82, alpha: 1))).multilineTextAlignment(.center)


                }
            }
            .padding(.horizontal, 10)
        }
        .frame(height: 91)
        .shadow(color: Color(#colorLiteral(red: 0.4166666865, green: 0.7666666508, blue: 1, alpha: 0.3000000119)), radius:7, x:0, y:7)
        .shadow(color: Color(#colorLiteral(red: 0.4166666865348816, green: 0.7666666507720947, blue: 1, alpha: 0.30000001192092896)), radius:7, x:3, y:0)
        .shadow(color: Color(#colorLiteral(red: 0.4166666865348816, green: 0.7666666507720947, blue: 1, alpha: 0.30000001192092896)), radius:7, x:-3, y:0)
        .onTapGesture{
            tapped = true
        }
        .sheet(isPresented: self.$tapped){
            ChatView(group: group, chat: $chat)
        }
    }
}

struct RecentChatRowSubview_Previews: PreviewProvider {
    static var previews: some View {
        RecentGroupRowSubview(group: Groups(id: "", groupID: "", groupName: "SAT Group", members: [""], interests: [nil]), profilePicture: Image("demoprofile"))
    }
}
