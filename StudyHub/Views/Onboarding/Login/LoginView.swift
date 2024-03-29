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
    @State private var password: String = ""
    @State private var email: String = ""
    @State var displayError = false
    @State var showLoadingAnimation = false
    @State var test = true
    @State var errorObject:ErrorModel = ErrorModel(errorMessage: "", errorState: false)
    @State var finishedOnboarding = false
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter:ViewRouter
    
    var body: some View {
        ZStack {
            
            VStack {
                TitleSubview(titleText: "Login", image: "login_drawing")
                InputFieldSubview(password: $password, email: $email)
                    .padding(.top,30)
                Spacer()
                ButtonsSubview(mainButtonAction: {showError()},
                               secondaryButtonAction:{self.viewRouter.updateCurrentView(view: .registration)}, displayMode: .login)
                    .padding(.top, 30)
                    .padding(.bottom)
            }
            .padding(.bottom, 22)
            .blur(radius: showLoadingAnimation ? 20 : 0)
            
            
            if showLoadingAnimation {
                VStack{
                    LottieUIView()
                        .animation(.easeInOut)
                    Text("Logging you in...")
                        .font(.custom("Montserrat-SemiBold", size: 25))
                        .offset(y: -40)
                        .foregroundColor(Color("Text"))
                }
                .frame(width: 300, height: 400)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .shadow(color: Color.black.opacity(0.3), radius: 15, x: 10, y: 10)
                .animation(.easeInOut)
                
            }
            if self.displayError {
                VStack {
                    ErrorMessage(errorObject: self.errorObject, displayError: self.displayError)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                                self.displayError = false
                            }
                        }
                    Spacer()
                }
                
            }
        }
        .onAppear {
            viewRouter.showTabBar = false
        }
        .background(
            ZStack {
                Color("Background")
                    .edgesIgnoringSafeArea(.all)
                FloatingBlobSubview()
            }
        )
    }
    func showError() -> Void {
        self.showLoadingAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.sendData{error, authResult in
                guard error.errorState == false else {
                    self.errorObject = error
                    self.displayError = true
                    return
                }
                if self.finishedOnboarding {
                    self.viewRouter.updateCurrentView(view: .home)
                    self.viewRouter.showTabBar = true
                } else {
                    self.viewRouter.updateCurrentView(view: .mentorCustom)
                }
            }
        }
        
        
    }
    func downloadImage() {
        
        let metadata = StorageMetadata()
        let storage = Storage.storage().reference().child("User_Profile/\(userData.userID)")
        storage.downloadURL { url, error in
            if let error = error {
                print("Error downloading image, \(error)")
            } else {
                userData.profilePictureURL = url!.absoluteString
            }
        }
    }
    func sendData(performActions: @escaping (ErrorModel, AuthDataResult?) -> Void) {
        Auth.auth().signIn(withEmail: self.email, password: self.password) { [] authResult, error in
            
            guard let authRusult = authResult else {
                self.showLoadingAnimation = false
                let newError = ErrorModel(errorMessage: error!.localizedDescription, errorState: true)
                performActions(newError, nil)
                return
            }
            let db = Firestore.firestore()
            let ref = db.collection("users")
            let query = ref.whereField("firebaseID", isEqualTo: authRusult.user.uid)
            query.getDocuments { snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let document = snapshot!.documents[0]
                    let result = Result {
                        try document.data(as: User.self)
                    }
                    switch result{
                    case .success(let user):
                        if let user=user{
                            self.userData.userID = user.id.uuidString
                            self.userData.name = user.name
                            let pushManager = PushNotificationManager(userID: user.id.uuidString)
                            pushManager.registerForPushNotifications()
                            downloadImage()
                            let didFinishOnboarding = user.finishedOnboarding ?? false
                            userData.isOnboardingCompleted = didFinishOnboarding
                            self.finishedOnboarding = didFinishOnboarding
                            checkSettings(userID: user.id.uuidString)
                        }
                        else{
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                    
                }
                self.showLoadingAnimation = false
                performActions(ErrorModel(errorMessage: "", errorState: false), authResult)
            }
            
        }
        
    }
    
    func checkSettings(userID: String) {
        let db = Firestore.firestore()
        let ref = db.collection("settings").document(userID)
        ref.getDocument { document, error in
            if let document = document, document.exists {
                let result = Result {
                    try document.data(as: SettingsData.self)
                }
                switch result {
                case .success(let settings):
                    print("Settings exists with new model")
                case .failure(let error):
                    print("Settings exists with previous model")
                    let newSettings = SettingsData(id: UUID(uuidString:userID)!)
                    do {
                        try ref.setData(from: newSettings)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                // Document does not exist. Create new settings document
                let newSettings = SettingsData(id: UUID(uuidString:userID)!)
                do {
                    try ref.setData(from: newSettings)
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}



