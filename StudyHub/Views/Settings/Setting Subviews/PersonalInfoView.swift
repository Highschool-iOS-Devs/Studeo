//
//  PersonalInfoView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 9/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase

struct PersonalInfoView: View {
    @ObservedObject var userData: UserData
    
    var body: some View {
        ZStack {
            
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Text("Personal Info")
                        .foregroundColor(Color("Text"))
                        .font(.custom("Montserrat-SemiBold", size: 25))
                    Spacer()
                }
                .padding(.vertical, 25)
                .padding(.horizontal)
                
                VStack {
                    PersonalInfoRow(userData: userData, text: "Username", otherText: userData.name)
                    // Find where the real name is stored
                    PersonalInfoRow(userData: userData, text: "Full Name", otherText: userData.name)
                    
                    Button(action: {
                        FirebaseManager.forgotPassword()
                    }) {
                        Text("Forgot password?")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                    }
                    .buttonStyle(BlueStyle())
                    .padding(.horizontal, 45)
                    .padding(.top, 25)
                    .padding(.bottom, 13)
                    
                    Button(action: {
                        // show popup text field and call updateEmail() on disappear
                        FirebaseManager.updateEmail("")
                    }) {
                        Text("Change Email")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                    }
                    .buttonStyle(WhiteStyle())
                    .padding(.horizontal, 45)

                }
                .padding(.vertical)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color("shadow"), radius: 5)
                .padding()
                Spacer()
            }
        }
    }
}

struct PersonalInfoRow: View {
    @ObservedObject var userData: UserData
    
    var text: String
    var otherText: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("Montserrat-SemiBold", size: 15))
                .foregroundColor(Color("Text").opacity(0.8))
            Spacer()
            Text(otherText)
                .font(.custom("Montserrat-SemiBold", size: 15))
                .foregroundColor(Color("Text").opacity(0.6))
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }
}

