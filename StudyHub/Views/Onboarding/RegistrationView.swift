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
import FirebaseStorage

struct RegistrationView: View {
    
    @State private var username: String = "A3"
    @State private var password: String = "perry1"
    @State private var email: String = "andreas.ink@wascholar.org"
    @State var errorObject: ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @State var displayError = false
    @State var test = false
    @State var showLoadingAnimation = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                
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
                                
                                self.showLoadingAnimation = true
                                self.sendData{error, authResult in
                                    guard error.errorState == false else {
                                        self.errorObject = error
                                        self.displayError = true
                                        return
                                    }
                                    self.userData.userID = authResult!.id.uuidString
                                    self.userData.name = authResult!.name
                                    self.viewRouter.updateCurrentView(view: .home)
                                    self.viewRouter.showTabBar = true
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
            }.blur(radius: showLoadingAnimation ? 20 : 0)
            
            if showLoadingAnimation{
                VStack{
                    LottieUIView()
                        .animation(.easeInOut)
                    Text("Creating an account...")
                        .font(.custom("Montserrat-SemiBold", size: 25))
                        .offset(y: -40)
                }
                .frame(width: 300, height: 400)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 10, y: 10)
                .animation(.easeInOut)
              
            }
            VStack{
                if self.displayError{
                    OnboardingErrorMessage(errorObject: self.$errorObject, displayError: self.$displayError)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                                self.displayError = false
                                self.displayError = false
                            }
                        }
                }
                Spacer()
            }
        }
        .onAppear{
            viewRouter.showTabBar = false
        }
      
        }
    func sendData(performActions: @escaping (ErrorModel, User?) -> Void) {
        Auth.auth().createUser(withEmail: self.email, password: self.password) { authResult, error in
            guard authResult != nil else {
                let newError = ErrorModel(errorMessage: error!.localizedDescription, errorState: true)
                self.showLoadingAnimation = false
                performActions(newError, nil)
                return
            }
            let db = Firestore.firestore()
            let newUserSettings = SettingsData(settings: [SettingSubData(name: "Notifications", state: true), SettingSubData(name: "Personal info", state: true), SettingSubData(name: "Country", field: "United States")])

            let newUser = User(id: UUID(), firebaseID: authResult!.user.uid, name: self.username, email: self.email, studyHours: 0, studyDate: "9-16-2020", all: 0, month: 0, day: 0, description: "Tap here to create your bio")
                    userData.userID = newUser.id.uuidString
            do{
                try db.collection("settings").document(newUser.id.uuidString).setData(from: newUserSettings)
                do{
                    try db.collection("users").document(newUser.id.uuidString).setData(from: newUser)
                }
                catch{
                    print("Error user to database, \(error)")
                }
            }
            catch{
                print("Error setting to database, \(error)")
            }
                   
                        
                
                self.showLoadingAnimation = false

                uploadImage()
                performActions(ErrorModel(errorMessage: "", errorState: false), newUser)
        }
            
           
    }
        
        func uploadImage() {
          
               let metadata = StorageMetadata()
               metadata.contentType = "image/jpeg"

               let storage = Storage.storage().reference()
            storage.child(userData.userID).putData(UIImage(named: "5293")!.jpegData(compressionQuality: 0.4)!, metadata: metadata) { meta, error in
                   if let error = error {
                       print(error)
                       return
                   }

                  
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
            .background(Color(#colorLiteral(red: 0.8578633666, green: 0.1455268264, blue: 0.1380874515, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(displayError ? 1 : 0)
            .offset(x: 0, y: displayError ? 0 : -200)
            .shadow(color: Color(#colorLiteral(red: 0.8578633666, green: 0.1455268264, blue: 0.1380874515, alpha: 1)).opacity(0.2), radius: 10, x: 0, y: 7)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))

    }
}

