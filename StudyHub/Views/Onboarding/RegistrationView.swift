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
        GeometryReader { geometry in
            VStack() {
                Text("Registration")
                    .font(Font.custom("Montserrat-SemiBold", size: 34))
                    .offset(x: 0, y: 23)
                Image("5293")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: geometry.size.width-30, height: geometry.size.height/3.25)
                    .padding(.horizontal)
                    .padding(.top, 12)
                    .padding(.bottom, 10)
                
                VStack(spacing: 20){
                    TextField("Username", text: self.$username)
                        .textFieldStyle(CustomTextField())
                    TextField("Email", text: self.$email)
                        .textFieldStyle(CustomTextField())
                    TextField("Password", text: self.$password)
                        .textFieldStyle(CustomTextField())
                }
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
                    Button(action: {
                        print("Tapped Sign-In button")
                    }) {
                        Text("Sign In")
                            .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                    }
                    .buttonStyle(WhiteStyle())
                }
                .padding(.horizontal, 75)
                .padding(.bottom, 50)
                Spacer()
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
