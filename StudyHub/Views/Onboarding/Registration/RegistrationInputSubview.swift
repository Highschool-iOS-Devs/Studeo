//
//  RegistrationInputSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct RegistrationInputSubview: View {
    @Binding var password: String
    @Binding var email: String
    @Binding var name: String
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color("Primary").opacity(0.2), radius: 3, x: 0, y: 5)
                    .padding(.leading)
                
                TextField("Name".uppercased(), text: $name)
                    .keyboardType(.alphabet)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.leading)
                    .frame(height: 44)
            }
            Divider().padding(.leading, 80).padding(.trailing, 15)
            HStack {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color("Primary").opacity(0.2), radius: 3, x: 0, y: 5)
                    .padding(.leading)
                
                TextField("Email".uppercased(), text: $email)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.leading)
                    .frame(height: 44)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
            }
            Divider().padding(.leading, 80).padding(.trailing, 15)
            HStack {
                Image(systemName: "lock.fill")
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color("Primary").opacity(0.2), radius: 3, x: 0, y: 5)
                    .padding(.leading)
                
                SecureField("Password".uppercased(), text: $password)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.leading)
                    .frame(height: 44)
                    .textContentType(.newPassword)
            }

        }
        .frame(maxWidth: .infinity)
        .frame(height:204)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 45)
        //.shadow(color: Color("aqua dark").opacity(0.1), radius: 15)
        .shadow(color: Color("Primary").opacity(0.2), radius: 30, x: 0, y: 30)
       
        .overlay(
            HStack {
                Spacer()
                VStack{
                    Spacer()
                    Text("Forgot password?")
                        .foregroundColor(Color.black.opacity(0.4))
                                .font(.custom("Montserrat-semibold", size: 14))
                        .padding(.trailing, 45)
                        .offset(y:35)
                }
            }
        )
    
    }
}
