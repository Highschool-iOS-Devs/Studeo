//
//  RegistrationView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct RegistrationView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Registration")
                .lineLimit(nil)
                .font(Font.custom("Montserrat-SemiBold", size: 34.0))
                .padding(.top, 64)
                .padding(.horizontal, 30)
            Image("5293")
                .resizable()
                .scaledToFit()
                .frame(width: 383, height: 200)
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .padding(.bottom, 30)
            TextField("Username", text: $username)
                .textFieldStyle(CustomTextField())
                .padding(.horizontal, 46)
                .padding(.bottom, 20)
            TextField("Email", text: $email)
                .textFieldStyle(CustomTextField())
                .padding(.horizontal, 46)
                .padding(.bottom, 20)
            TextField("Password", text: $password)
                .textFieldStyle(CustomTextField())
                .padding(.horizontal, 46)
                .padding(.bottom, 30)
            VStack(spacing: 35) {
                Button(action: {
                    print("Tapped Sign-Up button")
                }) {
                    Text("Sign Up")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                }
                .buttonStyle(BlueStyle())
                .padding(.horizontal, 75)
                Button(action: {
                    print("Tapped Sign-In button")
                }) {
                    Text("Sign In")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                }
                .buttonStyle(WhiteStyle())
                .padding(.horizontal, 75)
            }.padding(.bottom, 170)
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
