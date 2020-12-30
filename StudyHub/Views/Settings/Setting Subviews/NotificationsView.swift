//
//  NotificationsView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 9/19/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Network


let monitor = NWPathMonitor()
fileprivate var networkConected = false
struct NotificationsView: View {
    @EnvironmentObject var userData: UserData
    @Binding var chatNotifications: Bool
    @Binding var groupNotifications: Bool
    @State var displayError = false
    @State var errorObject = ErrorModel(errorMessage: "Settings can not be updated at this time", errorState: false)
    var body: some View {
        ZStack{
            
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                if displayError{
                    ErrorMessage(errorObject: errorObject, displayError: errorObject.errorState)
                }
            }
            VStack {
                HStack {
                    Text("Notifications")
                        .foregroundColor(Color("Text"))
                        .font(.custom("Montserrat-SemiBold", size: 25))
                    Spacer()
                }
                .padding(.vertical, 25)
                .padding(.horizontal)
                
                VStack {
                    NotificationRow(text: "Enable Chat Notifications", subText: "Get notified when a new message is sent", settingsVar: $chatNotifications, displayError: $displayError)
                    NotificationRow(text: "Enable New Group Notifications", subText: "Get notified when we find you a new group", settingsVar: $groupNotifications, displayError: $displayError)
                }
                .padding(.vertical)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color("shadow"), radius: 5)
                .padding()
                Spacer()
            }
            .onAppear{
                monitor.pathUpdateHandler = {path in
                    if path.status == .satisfied{
                        print("Connected")
                        networkConected = true

                    }
                    else{
                        networkConected = false
                        print("Disconnected")
                        
                    }
                }
                let quene = DispatchQueue(label: "Monitor")
                monitor.start(queue: quene)
            }
        }
    
}

struct NotificationRow: View {
    @EnvironmentObject var userData: UserData
    var text: String
    var subText: String
    @Binding var settingsVar: Bool
    @Binding var displayError:Bool
    var body: some View {
        HStack {
            Toggle(isOn: $settingsVar) {
                VStack(alignment: .leading, spacing: 5){
                    Text(text)
                        .foregroundColor(Color("Text"))
                        .font(.custom("Montserrat-SemiBold", size: 14))
                        .opacity(0.8)
                        .lineLimit(1)
                    Text(subText)
                        .foregroundColor(Color("Text"))
                        .font(.custom("Montserrat-Regular", size: 11))
                        .opacity(0.6)
                        .lineLimit(1)
                }
            }
            .onChange(of: settingsVar){ value in
                if networkConected == false{
                    displayError = true
                } else {
                    let task = DispatchWorkItem{settingsVar.toggle()}
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.1,execute: task)
                    task.cancel()
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
       
        
    }
}
}
//struct NotificationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        NotificationsView()
//    }
//}
