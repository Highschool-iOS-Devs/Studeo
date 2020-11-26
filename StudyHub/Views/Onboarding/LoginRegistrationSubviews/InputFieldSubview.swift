//
//  InputFieldSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct InputFieldSubview: View {
    @Binding var password: String
    @Binding var email: String
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .frame(width: 44, height: 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color("aqua dark").opacity(0.2), radius: 3, x: 0, y: 5)
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
                    .shadow(color: Color("aqua dark").opacity(0.2), radius: 3, x: 0, y: 5)
                    .padding(.leading)
                
                SecureField("Password".uppercased(), text: $password)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.leading)
                    .frame(height: 44)
                    .textContentType(.password)
            }

        }
        .frame(maxWidth: .infinity)
        .frame(height:136)
        .background(BlurView(style: .systemMaterial))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding(.horizontal, 45)
        .shadow(color: Color("aqua dark").opacity(0.1), radius: 15)
        .shadow(color: Color("aqua dark").opacity(0.2), radius: 25, x: 0, y: 20)

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

struct InputFieldSubview_Previews: PreviewProvider {
    static var previews: some View {
        InputFieldSubview(password: .constant("12345"), email: .constant("email@email.com"))
    }
}
