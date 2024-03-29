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
import Combine

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    @State var errorObject: ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @State var displayError = false
    @State var test = false
    @State var showLoadingAnimation = false
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewRouter: ViewRouter
    @ObservedObject var userData: UserData
    @State var keyboardHeight: CGFloat = 0.0
    var body: some View {
        ZStack {
            
            VStack {
                TitleSubview(titleText: "Registration", image: "registration_drawing")
                
                TextField("Name".uppercased(), text: $username)
                    .lineLimit(nil)
                    .keyboardType(.alphabet)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.horizontal)
                    .frame(height: 44)
                    .padding(.trailing, 15)
                    .accessibility(hint: Text("Enter the username for your new account"))
                
                TextField("Email".uppercased(), text: $email)
                    .lineLimit(nil)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.horizontal)
                    .frame(height: 44)
                    .autocapitalization(.none)
                    .textContentType(.emailAddress)
                    .padding(.trailing, 15)
                    .accessibility(hint: Text("Enter the email address for your new account"))
                
                
                SecureField("Password".uppercased(), text: $password)
                    .lineLimit(nil)
                    .font(.subheadline)
                    .foregroundColor(Color(#colorLiteral(red: 0.6549019608, green: 0.7137254902, blue: 0.862745098, alpha: 1)))
                    .padding(.horizontal)
                    .frame(height: 44)
                    .textContentType(.newPassword)
                    .padding(.trailing, 15)
                Spacer()
                ButtonsSubview(mainButtonAction: {
                    parseData()
                }, secondaryButtonAction: { self.viewRouter.updateCurrentView(view: .login)}, displayMode: .registration)
                .padding(.top, 30)
                .padding(.bottom, 30)
                
                
                
            } //.padding(.bottom, 62)
            .blur(radius: showLoadingAnimation ? 20 : 0)
            .onAppear{
                viewRouter.showTabBar = false
            }
            
            if showLoadingAnimation {
                VStack{
                    LottieUIView()
                        .animation(.easeInOut)
                    Text("Creating an account...")
                        .font(.custom("Montserrat-SemiBold", size: 25))
                        .offset(y: -40)
                        .foregroundColor(Color("Text"))
                }
                .frame(width: 300, height: 400)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color("Text").opacity(0.3), radius: 15, x: 10, y: 10)
                .animation(.easeInOut)
                
            }
            VStack{
                if self.displayError {
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
            ZStack {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                FloatingBlobSubview()
            }
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
            uploadImage()
            self.viewRouter.updateCurrentView(view: .mentorCustom)
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
            let newUserID = UUID()
            let newUserSettings = SettingsData(id: newUserID)
            
            let newUser = User(id: newUserID, firebaseID: authResult!.user.uid, name: self.username, email: self.email, isMentor: false, studyHours: [0], studyDate: ["9-16-2020"], all: 0, month: 0, day: 0, description: "Edit your bio", isAvailable: true, finishedOnboarding: false)
            
            userData.userID = newUser.id.uuidString
            
            let pushManager = PushNotificationManager(userID: newUser.id.uuidString)
            pushManager.registerForPushNotifications()
            do{
                try db.collection("settings").document(newUser.id.uuidString).setData(from: newUserSettings)
                do {
                    try db.collection("users").document(newUser.id.uuidString).setData(from: newUser)
                }
                catch {
                    print("Error user to database, \(error)")
                }
            }
            catch {
                print("Error setting to database, \(error)")
            }
            
            
            
            self.showLoadingAnimation = false
            
            performActions(ErrorModel(errorMessage: "", errorState: false), newUser)
        }
        
        
    }
    
    
    func uploadImage() {
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        let storage = Storage.storage().reference().child("User_Profile/\(userData.userID)")
        let imagePlaceholder = UIImage(named: "placeholder")!
        
        storage.putData(imagePlaceholder.pngData()!, metadata: metadata) { meta, error in
            if let error = error{
                print("Error uploading image, \(error)")
                return
            }
            storage.downloadURL { url, error in
                if let error = error {
                    print("Error downloading image, \(error)")
                } else {
                    userData.profilePictureURL = url!.absoluteString
                }
            }
        }
        
    }
    
    
    
}


