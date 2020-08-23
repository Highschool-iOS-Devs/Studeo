//
//  LoginView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        VStack() {
            Text("Login")
                .font(Font.custom("Montserrat-SemiBold", size: 34))
                .offset(x: 0, y: 30)

            Image("studying")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 280, height: 280)
            .offset(x: 0, y: 30)
                .padding(.horizontal, 42)
            TextField("Username", text: $username)
                .textFieldStyle(CustomTextField())
                .padding(.horizontal, 46)
                .padding(.bottom, 20)
            TextField("Password", text: $password)
                .textFieldStyle(CustomTextField())
                .padding(.horizontal, 46)
                .padding(.bottom, 10)
            Text("Forgot password?")
                .font(.caption)
                .offset(x: 100)
                .padding(.bottom, 61)
            
            Spacer()
            
            VStack(spacing: 35) {
                Button(action: {
                    print("Tapped Sign-in button")
                }) {
                    Text("Sign in")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                }
                .buttonStyle(BlueStyle())
                .padding(.horizontal, 75)
                Button(action: {
                    print("Tapped Sign-Up button")
                }) {
                    Text("Sign Up")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                }
                .buttonStyle(WhiteStyle())
                .padding(.horizontal, 75)
            }.padding(.bottom, 50)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
