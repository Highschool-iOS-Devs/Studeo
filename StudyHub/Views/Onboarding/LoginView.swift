//
//  LoginView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct LoginView: View {
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State var displayError = false
    @State var errorObject:ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                if self.displayError{
                    OnboardingErrorMessage(errorObject: self.$errorObject, displayError: self.$displayError)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                                print("Error disappear")
                                self.displayError = false
                            }
                    }
                    
                }
                Text("Login")
                    .font(Font.custom("Montserrat-SemiBold", size: 34))
                //.offset(x: 0, y: 23)
                
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
                        print("Tapped Sign-in button")
                        self.sendData{error, authResult in
                            guard error.errorState == false else {
                                self.errorObject = error
                                self.displayError = true
                                return
                            }
                            self.viewRouter.updateCurrentView(view: .chatList)
                        }
                    }) {
                        Text("Sign in")
                            .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                    }
                    .buttonStyle(BlueStyle())
                    .padding(.horizontal, 46)
                    Button(action: {
                        self.viewRouter.updateCurrentView(view: .registration)
                        print("Tapped Sign-Up button")
                    }) {
                        
                        Text("Sign Up")
                            .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                    }
                    .buttonStyle(WhiteStyle())
                    .padding(.horizontal, 46)
                }
                Spacer()
            } .padding(.bottom, 22)
        }
    }
    func sendData(performActions: @escaping (ErrorModel, AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { [] authResult, error in
            
            guard authResult != nil else {
                let newError = ErrorModel(errorMessage: error!.localizedDescription, errorState: true)
                performActions(newError, nil)
                return
            }
            
            var db: Firestore!
            db = Firestore.firestore()
            
            let defaults = UserDefaults.standard
            let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
            
            pushManager.registerForPushNotifications()
            self.userData.name = self.username
            let token = defaults.string(forKey: "fcmToken")
            db.collection("users").document(Auth.auth().currentUser!.uid).setData([
                "name": self.username,
                "id": Auth.auth().currentUser!.uid,
                "hours": [0.0],
                "image": "",
                "school": [0.0,0.0],
                "hoursDate": [Date()],
                "interactedPeople": [Auth.auth().currentUser!.uid],
                "interactedChatRooms": ["\(UUID())"],
                "fcmToken": token,
                "SAT": true,
            ]) { error in
                guard error == nil
                    else {
                        print("Error writing document, \(String(describing: error))")
                        return
                }
                performActions(ErrorModel(errorMessage: "", errorState: false), authResult)
            }
            
            //self.presentationMode.wrappedValue.dismiss()
        }
        
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
