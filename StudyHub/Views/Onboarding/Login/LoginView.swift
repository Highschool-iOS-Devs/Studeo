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
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    
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
                    ErrorMessage(errorObject: self.errorObject, displayError: self.displayError)
                        .onAppear{
                            
                            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                                self.displayError = false
                            }
                        }
                    Spacer()
                }
                
            }
        }
        .onAppear{
            viewRouter.showTabBar = false
        }
        .background(
            FloatingBlobSubview()
        )
    }
    func showError() -> Void{
            self.showLoadingAnimation = true
            DispatchQueue.main.asyncAfter(deadline: .now()+2){
                self.sendData{error, authResult in
                    guard error.errorState == false else {
                        self.errorObject = error
                        self.displayError = true
                        return
                    }
                    self.viewRouter.updateCurrentView(view: .home)
                    self.viewRouter.showTabBar = true
                    
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
            query.getDocuments{snapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    let document = snapshot!.documents[0]
                let result = Result{
                    try document.data(as: User.self)
                    }
                    switch result{
                    case .success(let user):
                        if let user=user{
                            self.userData.userID = user.id.uuidString
                            self.userData.name = user.name
                            if let url = user.profileImageURL{
                                self.userData.profilePictureURL = url.absoluteString

                            }
                            userData.isOnboardingCompleted = true
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
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



