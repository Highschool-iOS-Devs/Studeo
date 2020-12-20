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
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State var errorObject: ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @State var displayError = false
    @State var test = false
    @State var showLoadingAnimation = false
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
                VStack {
                        TitleSubview(titleText: "Registration", image: "registration_drawing")
                        
                        RegistrationInputSubview(password: $password, email: $email, name: $username)
                            .padding(.top)
                        Spacer()
                        ButtonsSubview(mainButtonAction: {
                          parseData()
                        }, secondaryButtonAction: {self.viewRouter.updateCurrentView(view: .login)}, displayMode: .registration)
                        .padding(.top, 30)
                        .padding(.bottom)
                    }
                    .blur(radius: showLoadingAnimation ? 20 : 0)
                    .onAppear{
                        viewRouter.showTabBar = false
                    }
                    
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
                    ErrorMessage(errorObject: self.errorObject, displayError: self.displayError)
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
        .background(
            FloatingBlobSubview()
        )
    }
    func parseData(){
            self.showLoadingAnimation = true
            self.sendData{error, authResult in
                guard error.errorState == false else {
                    self.errorObject = error
                    self.displayError = true
                    return
                }
                self.userData.userID = authResult!.id.uuidString
                self.userData.name = authResult!.name
                self.viewRouter.updateCurrentView(view: .custom)
               // self.viewRouter.showTabBar = true
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
            let newUserSettings = SettingsData(settings: [SettingSubData(name: "Notifications", state: true), SettingSubData(name: "Personal info", state: true), SettingSubData(name: "Country", field: "US")])

            let newUser = User(id: UUID(), firebaseID: authResult!.user.uid, name: self.username, email: self.email, studyHours: [0], studyDate: ["9-16-2020"], all: 0, month: 0, day: 0, description: "Tap here to create your bio", isAvailable: true)
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


