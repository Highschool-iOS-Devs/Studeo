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
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack {
            HStack {
                Text("Personal Info")
                    .foregroundColor(.black)
                    .font(.custom("Montserrat-SemiBold", size: 25))
                Spacer()
            }
            .padding(.vertical, 25)
            .padding(.horizontal)
            
            VStack {
                PersonalInfoRow(text: "Username", otherText: userData.name)
                // Find where the real name is stored
                PersonalInfoRow(text: "Full Name", otherText: userData.name)
                
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
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .shadow(radius: 5)
            .padding()
            Spacer()
        }
    }
}

struct PersonalInfoRow: View {
    @EnvironmentObject var userData: UserData
    
    var text: String
    var otherText: String
    
    var body: some View {
        HStack {
            Text(text)
                .font(.custom("Montserrat-SemiBold", size: 15))
                .foregroundColor(Color.black.opacity(0.6))
            Spacer()
            Text(otherText)
                .font(.custom("Montserrat-SemiBold", size: 15))
                .foregroundColor(Color.black.opacity(0.4))
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 10)
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView()
    }
}
