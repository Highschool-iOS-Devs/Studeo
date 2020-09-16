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
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RegistrationView: View {
    
    @State private var username: String = "A3"
    @State private var password: String = "perry1"
    @State private var email: String = "andreas.ink@wascholar.org"
    @State var errorObject: ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @State var displayError = false
    @State var test = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack() {
                    if self.displayError{
                        OnboardingErrorMessage(errorObject: self.$errorObject, displayError: self.$displayError)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now()+3){
                                    self.displayError = false
                                }
                            }
                    }
                    Text("Registration")
                        .font(Font.custom("Montserrat-SemiBold", size: 34))
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
                        TextField("Password", text: self.$password)
                            .textFieldStyle(CustomTextField())
                    }
                    .padding(.horizontal, 46)
                    .padding(.bottom, 30)
                    
                    VStack(spacing: 35) {
                        Button(action: {
                            self.sendData{error, authResult in
                                guard error.errorState == false else {
                                    self.errorObject = error
                                    self.displayError = true
                                    return
                                }
                                self.userData.userID = authResult!.id.uuidString
                                self.userData.name = authResult!.name
                                self.viewRouter.updateCurrentView(view: .chatList)
                            }
                    
                        }) {
                            Text("Sign up")
                                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                        }
                        .buttonStyle(BlueStyle())
                        Button(action: {
                            self.viewRouter.updateCurrentView(view: .login)
                            
                        }) {
                            Text("Log in")
                                .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                        }
                        .buttonStyle(WhiteStyle())
                    }  .padding(.horizontal, 46)
                }
            }
        }
    
    func sendData(performActions: @escaping (ErrorModel, User?) -> Void) {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            guard authResult != nil else {
                let newError = ErrorModel(errorMessage: error!.localizedDescription, errorState: true)
                performActions(newError, nil)
                return
            }
            
            let db = Firestore.firestore()
            

            let newUser = User(id: UUID(), firebaseID: authResult!.user.uid, name: self.username, email: self.email, studyHours: 0, studyDate: "9-16-2020")
                do {
                        try db.collection("users").document(newUser.id.uuidString).setData(from: newUser)
                         } catch let error {
                             print("Error writing to Firestore: \(error)")
                         }
                performActions(ErrorModel(errorMessage: "", errorState: false), newUser)

            
         
            }
        }
    }


struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}

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
