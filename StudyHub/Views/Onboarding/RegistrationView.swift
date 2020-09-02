//
//  RegistrationView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct RegistrationView: View {
    
    @State private var username: String = "A2"
    @State private var password: String = "perry1"
    @State private var email: String = "andreasink@outlook.com"
    @State var errorObject:ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @State var displayError = false
    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var viewRouter:ViewRouter

    @EnvironmentObject var userData: UserData
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
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
                        
                    Text("Registration")
                        .font(Font.custom("Montserrat-SemiBold", size: 34))
                        //.offset(x: 0, y: 23)
                    
                        .onAppear() {
                            Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
                                guard authResult != nil else {
                                    
                                    return
                                }
                                self.userData.name = self.username
                                var db: Firestore!
                                db = Firestore.firestore()
                                let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
                                pushManager.registerForPushNotifications()
                                let defaults = UserDefaults.standard
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
                                    
                                }
                            }
                            
                                   }
                    }
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
                        SecureField("Password", text: self.$password)
                            .textFieldStyle(CustomTextField())
                    }
                    .padding(.horizontal, 46)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 35) {
                        Button(action: {
                            print("Tapped Sign-Up button")
                            self.sendData{error, authResult in
                                guard error.errorState == false else {
                                    self.errorObject = error
                                    self.displayError = true
                                    return
                                }
                                self.viewRouter.updateCurrentView(view: .chatList)
                            }
                            
                        }) {
                            Text("Sign up")
                                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                        }
                        .buttonStyle(BlueStyle())
                        Button(action: {
                            self.viewRouter.updateCurrentView(view: .login)
                            print("Tapped Sign-In button")
                            
                        }) {
                            Text("Log in")
                                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                        }
                        .buttonStyle(WhiteStyle())
                    }  .padding(.horizontal, 46)
                } .padding(.bottom, 85)
            }
        }
    


    func sendData(performActions: @escaping (ErrorModel, AuthDataResult?) -> Void) {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            guard authResult != nil else {
                let newError = ErrorModel(errorMessage: error!.localizedDescription, errorState: true)
                performActions(newError, nil)
                return
            }
                self.userData.name = self.username
                var db: Firestore!
                db = Firestore.firestore()
                let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
                pushManager.registerForPushNotifications()
                let defaults = UserDefaults.standard
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
            }
            
        }

    }


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
//        func sendData() {
//            Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
//                               if error != nil {
//                                withAnimation{
//                              self.error.toggle()
//                               }
//                               } else {
//                              self.userData.name = self.username
//                              var db: Firestore!
//                                     db = Firestore.firestore()
//                              let pushManager = PushNotificationManager(userID: Auth.auth().currentUser!.uid)
//                              pushManager.registerForPushNotifications()
//                              let defaults = UserDefaults.standard
//                              let token = defaults.string(forKey: "fcmToken")
//                               db.collection("users").document(Auth.auth().currentUser!.uid).setData([
//                                  "name": self.username,
//                                  "id": Auth.auth().currentUser!.uid,
//                                  "hours": [0.0],
//                                  "image": "",
//                                  "school": [0.0,0.0],
//                                  "hoursDate": [Date()],
//                                  "interactedPeople": [Auth.auth().currentUser!.uid],
//                                  "interactedChatRooms": ["\(UUID())"],
//                                  "fcmToken": token,
//                                  "SAT": true,
//                              ]) { err in
//                                  if let err = err {
//                                      print("Error writing document: \(err)")
//                                      withAnimation() {
//                                          print("bad")
//                                          self.error.toggle()
//                                          print(error)
//                                      }
//                                  } else {
//
//                                      print("Document successfully written!")
//                                     // self.presentationMode.wrappedValue.dismiss()
//
//                                    self.presentationMode.wrappedValue.dismiss()
//                                  }
//                              }
//                          }
//
//    }

struct OnboardingErrorMessage: View {
    @Binding var errorObject:ErrorModel
    @Binding var displayError:Bool
    var body: some View {
        Text("\(errorObject.errorMessage)")
            .animation(nil)
            .foregroundColor(.white)
            .frame(width: screenSize.width-15, height: 60)
            .background(Color(#colorLiteral(red: 0.8588235294, green: 0.1019607843, blue: 0.1019607843, alpha: 0.7)))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(displayError ? 1 : 0)
            .offset(x: 0, y: displayError ? 0 : -200)
            .shadow(color: Color(#colorLiteral(red: 0.8588235294, green: 0.1019607843, blue: 0.1019607843, alpha: 0.7)).opacity(0.3), radius: 10, x: 0, y: 7)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))

    }
}
