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
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    VStack {
                        profilePictureCircle()
                        Text("John R.")
                        .font(.custom("Montserrat-Bold", size: 28))
                        .padding(.top, 10)
                    }.padding(.top, 20)
                   
                    
                    Spacer(minLength: 50)
                    
                    VStack(alignment:.leading) {
                        
                        Text("Account Settings")
                            .font(.custom("Montserrat-Bold", size: 16))
                            .foregroundColor(.black)
                            .padding(.bottom, 25)
                            .padding(.top, 40)
                            .padding(.horizontal, 22)
                        VStack(spacing: 30) {
                           
                            settingRowView(settingText: "Notifications", settingState: "On", newView: AnyView(NotificationsView()))
                            settingRowView(settingText: "Personal info", settingState: "", newView: AnyView(PersonalInfoView()))
                            settingRowView(settingText: "Country", settingState: "United States", newView: AnyView(Text("Placeholder")))
                            settingRowView(settingText: "Language", settingState: "English", newView: AnyView(Text("Placeholder")))
                            settingRowView(settingText: "Sign out", settingState: "", newView: AnyView(Text("Placeholder")), disableNavigation: true)
                                .onTapGesture(){
                                    FirebaseManager.signOut()
                                    viewRouter.updateCurrentView(view:.login)
                                }
                            settingRowView(settingText: "Help", settingState: "", newView: AnyView(Text("Placeholder")))
                        }
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(radius: 5)
                    .padding(.horizontal, 10)
                    Spacer(minLength: 120)
                } 
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
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
        var newView: AnyView
        var disableNavigation:Bool = false
        var body: some View {
            HStack{
              
                NavigationLink(destination: newView) {
                    Text(settingText)
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(.black)
                        .opacity(0.4)
                        
                    Spacer()
                    
                    Text(settingState)
                        .frame(width: 50)
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .lineLimit(1)
                        .foregroundColor(.black)
                        .opacity(0.4)
                        .padding(.trailing, 5)
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color("barCenter"))
                        .font(Font.system(size: 13).weight(.semibold))
                }.disabled(disableNavigation)
                
            } .padding(.horizontal, 22)
           
            
        }
    }
}

