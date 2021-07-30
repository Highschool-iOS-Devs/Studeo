//
//  PasswordResetView.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct PasswordResetView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var email = ""
    @State var showAlert = false
    var body: some View {
        VStack {
            HStack {
                Button(action: {presentationMode.wrappedValue.dismiss()}){
                    Image(systemName: "xmark")
                        .foregroundColor(Color("Text"))
                        .font(Font.custom("Montserrat", size: 20))
                }
                Spacer()
                Text("Reset Password")
                    .font(Font.custom("Montserrat-SemiBold", size: 34))
                    .foregroundColor(Color("Text"))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 20)
            Spacer()
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .frame(width: 44, height: 44)
                    .background(Color("IconBackground"))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .shadow(color: Color("Primary").opacity(0.2), radius: 3, x: 0, y: 5)
                    .padding(.leading)
                    .accessibility(hidden: true)
                
                TextField("Email".uppercased(), text: $email)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.horizontal)
                    .frame(height: 44)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .padding(.trailing, 15)
                
            }
            .frame(maxWidth: .infinity)
            .frame(height:80)
            .background(BlurView(style: .systemMaterial))
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 45)
            .padding(.bottom, 20)
            .shadow(color: Color("Primary").opacity(0.1), radius: 15)
            .shadow(color: Color("Primary").opacity(0.2), radius: 25, x: 0, y: 20)
            
            Button(action: {
                if email != ""{
                    Auth.auth().sendPasswordReset(withEmail: email) { error in
                        showAlert = true
                    }
                }
            }){
                
                Text("Send reset email")
                    .font(Font.custom("Montserrat-SemiBold", size: 16.0))
                    .foregroundColor(Color("Background"))
                
            }
            .buttonStyle(BlueStyle())
            .padding(.horizontal, 30)
            Spacer()
        }
        .alert(isPresented: $showAlert){
            Alert(title: Text("Email sent!"), message: Text("Please check your email for password reset instructions."))
        }
        .background(Color("Background"))
        
    }
}

struct PasswordResetView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordResetView()
    }
}
