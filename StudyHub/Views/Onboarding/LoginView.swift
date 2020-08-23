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
        GeometryReader { geometry in
            VStack() {
                Text("Login")
                    .font(Font.custom("Montserrat-SemiBold", size: 34))
                    .offset(x: 0, y: 23)
                
                Image("studying")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 280, height: geometry.size.height/3.2)
                    .padding(.horizontal, 42)
                
                VStack(spacing: 20) {
                    TextField("Username", text: self.$username)
                        .textFieldStyle(CustomTextField())
                    TextField("Password", text: self.$password)
                        .textFieldStyle(CustomTextField())
                }
                .padding(.horizontal, 46)
                Text("Forgot password?")
                    .font(.caption)
                    .offset(x: 100)
                    .padding(.bottom, 50)
                            
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
                }
                Spacer()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
