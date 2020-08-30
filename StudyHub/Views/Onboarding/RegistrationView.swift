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
    
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State var error: Bool = false

    @Environment(\.presentationMode) var presentationMode

    @EnvironmentObject var viewRouter:ViewRouter

    @EnvironmentObject var userData: UserData
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
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
                            self.sendData{error in
                                guard error != nil else {return}
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

    func sendData(performActions: @escaping (Error?) -> Void) {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            if error != nil {
                
                performActions(error)
                withAnimation{
                    self.error.toggle()
                }
            } else {
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
                ]) { err in
                    if let err = err {
                        performActions(error)
                        print("Error writing document: \(err)")
                        withAnimation() {
                            print("bad")
                            self.error.toggle()
                            print(error)
                        }
                    } else {
                        
                        print("Document successfully written!")
                        // self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            
        }

    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
