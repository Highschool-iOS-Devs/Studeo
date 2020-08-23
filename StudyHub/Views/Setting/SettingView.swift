//
//  SettingView.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

let screenSize = UIScreen.main.bounds.size

struct SettingView: View {
    var body: some View {
        NavigationView{
            VStack {
                VStack {
                    profilePictureCircle()
                    Text("John R.")
                    .font(.custom("Montserrat-Bold", size: 28))
                    .padding(.top, 10)
                }
                .offset(x: 0, y: -50)
                
                Spacer()
                
                VStack(alignment:.leading) {
                    
                    Text("Account Settings")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.black)
                        .padding(.bottom, 25)
                        .padding(.top, 40)
                    VStack(spacing: 30) {
                       
                        settingRowView(settingText: "Notifications", settingState: "On")
                        settingRowView(settingText: "Personal info", settingState: "Name Age")
                        settingRowView(settingText: "Country", settingState: "United States")
                        settingRowView(settingText: "Language", settingState: "English")
                        settingRowView(settingText: "Password settings", settingState: "")
                        settingRowView(settingText: "Sign out", settingState: "")
                        settingRowView(settingText: "Help", settingState: "")
                    }
                    Spacer()
                }   .padding(.horizontal, 30)
                    .frame(maxWidth: screenSize.width-60)
                    .frame(height: 600)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(radius: 10)
                    .offset(x: 0, y: 20)

            }
        }
    }
    
    struct SettingView_Previews: PreviewProvider {
        static var previews: some View {
            SettingView()
        }
    }
    
    struct profilePictureCircle: View {
        var body: some View {
            Circle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 52, height: 52)
                .overlay(
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.gradientLight, Color.gradientDark]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 50, height: 50)
                        .overlay(Image("demoprofile")
                            
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            
                    )
            )
        }
    }
    
    struct settingRowView: View {
        var settingText:String
        var settingState:String
        
        var body: some View {
            HStack{
                Text(settingText)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .opacity(0.4)
                Spacer()
                
                Text(settingState)
                    .frame(width: 50)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .lineLimit(1)
                    .opacity(0.4)
                    .padding(.trailing, 5)
                Image(systemName: "chevron.right")
                    .font(Font.system(size: 13).weight(.semibold))
                
                
                
            }
           
            
        }
    }
}
