//
//  LoginView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseCore

struct LoginView: View {
    
    @State private var username: String = "A2"
    @State private var password: String = "perry1"
    @State private var email: String = "andreasink@outlook.com"
    @State var displayError = false
    @State var showLoadingAnimation = false
    @State var test = true
    
    @State var errorObject:ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    
    
    var body: some View {
        ZStack {
        
            GeometryReader { geometry in
                VStack {
                   
                    Text("Login")
                        .font(Font.custom("Montserrat-SemiBold", size: 34))
                  
                    Image("studying")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 280, height: geometry.size.height/3.2)
                        .padding(.horizontal, 42)
                    
                    VStack(spacing: 20) {
                        TextField("Email", text: self.$email)
                            .textFieldStyle(CustomTextField())
                        SecureField("Password", text: self.$password)
                            .textFieldStyle(CustomTextField())
                    }
                    .padding(.horizontal, 46)
                    Text("Forgot password?")
                        .font(.caption)
                        .offset(x: 100)
                        .padding(.bottom, 50)
                    
                    VStack(spacing: 35) {
                        Button(action: {
                            showLoadingAnimation = true
                            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                            self.sendData{error, authResult in
                                guard error.errorState == false else {
                                    self.errorObject = error
                                    self.displayError = true
                                    return
                                }
                                self.viewRouter.updateCurrentView(view: .chatList)
                                
                            }
                            }
                        }) {
                            Text("Sign in")
                                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                        }
                        .buttonStyle(BlueStyle())
                        .padding(.horizontal, 46)
                        Button(action: {
                            self.viewRouter.updateCurrentView(view: .registration)
                        }) {
                            
                            Text("Sign Up")
                                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                        }
                        .buttonStyle(WhiteStyle())
                        .padding(.horizontal, 46)
                    }
                    Spacer()
                } .padding(.bottom, 22)
            }.blur(radius: showLoadingAnimation ? 20 : 0)
            if showLoadingAnimation{
                VStack{
                    LottieUIView()
                        .animation(.easeInOut)
                    Text("Logging you in...")
                        .font(.custom("Montserrat-SemiBold", size: 25))
                        .offset(y: -40)
                }
                .frame(width: 300, height: 400)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 10, y: 10)
                .animation(.easeInOut)
              
            }
            if self.displayError{
                VStack {
                    OnboardingErrorMessage(errorObject: self.$errorObject, displayError: self.$displayError)
                        .onAppear{
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                                self.displayError = false
                            }
                    }
                    Spacer()
                }
                
            }
        }
      
    }
    func sendData(performActions: @escaping (ErrorModel, AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { [] authResult, error in
            
            guard let authRusult = authResult else {
                showLoadingAnimation = false
                let newError = ErrorModel(errorMessage: error!.localizedDescription, errorState: true)
                performActions(newError, nil)
                return
            }
                let db = Firestore.firestore()
                let ref = db.collection("users")
            let query = ref.whereField("firebaseID", isEqualTo: authRusult.user.uid)
            query.getDocuments{snapshot, error in
                if let error = error {
                          print("Error getting documents: \(error)")
                      } else {
                    if snapshot!.documents.count > 1{
                        fatalError("Error, multiple user with the same ID exists.")
                    }
                    for document in snapshot!.documents{
                        self.userData.userID = document["id"] as! String
                        self.userData.name = document["name"] as! String
                    } 
                
            }
                showLoadingAnimation = false
                performActions(ErrorModel(errorMessage: "", errorState: false), authResult)
            }
            
        }
        
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


