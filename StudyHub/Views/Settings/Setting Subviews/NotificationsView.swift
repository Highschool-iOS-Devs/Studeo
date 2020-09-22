//
//  NotificationsView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 9/19/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            HStack {
                Text("Notifications")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 25))
                Spacer()
            }
            .padding(.vertical, 25)
            .padding(.horizontal)
            
            VStack {
                NotificationRow(text: "Enable Chat Notifications", subText: "Get notified when a new message is sent", settingsVar: $userData.chatNotificationsOn)
                NotificationRow(text: "Enable New Group Notifications", subText: "Get notified when we find you a new group", settingsVar: $userData.joinedGroupNotificationsOn)
            }
            .padding(.vertical)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(radius: 5)
            .padding()
            Spacer()
        }
    }
}

struct NotificationRow: View {
    @EnvironmentObject var userData: UserData
    
    var text: String
    var subText: String
    @Binding var settingsVar: Bool
    
    var body: some View {
        HStack {
            Toggle(isOn: $settingsVar) {
                VStack(alignment: .leading, spacing: 5){
                    Text(text)
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .opacity(0.6)
                        .lineLimit(1)
                    Text(subText)
                        .font(.custom("Montserrat-Regular", size: 9))
                        .opacity(0.4)
                        .lineLimit(1)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
       
        
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
