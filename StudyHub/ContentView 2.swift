//
//  ContentView.swift
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

struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @State private var hasCheckedAuth = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showSheet = false

    var body: some View {
        ZStack { 
            Color.white
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    self.checkAuth()
                    
            }
            if self.hasCheckedAuth {
               
                if viewRouter.currentView == .registration{
                    RegistrationView()
                        .environmentObject(viewRouter)
                }
                else if viewRouter.currentView == .login {
                    LoginView()
                        .environmentObject(viewRouter)
                }
                else if viewRouter.currentView == .chatList {
                    RecentsView()
                        .environmentObject(userData)

                }
                else if viewRouter.currentView == .groups {
                    AddChat()
                        .environmentObject(userData)

                }
                else if viewRouter.currentView == .profile {
                    ProfileView()
                        .environmentObject(userData)
                        .environmentObject(viewRouter)
                    
                }
                else if viewRouter.currentView == .leaderboard {
                    LeaderboardView()
                        .environmentObject(userData)
                }
                else if viewRouter.currentView == .home {
                    Home()
                        .environmentObject(userData)
                }
                else if viewRouter.currentView == .settings{
                    SettingView()
                        .environmentObject(viewRouter)
                        .environmentObject(userData)
                }
                else if viewRouter.currentView == .introView{
                    OnBoardCustomPage()
                        .environmentObject(viewRouter)
                        .environmentObject(userData)
                }
            }
      
            if viewRouter.showTabBar{
                VStack{
                    Spacer()
                    tabBarView()
                        
                }.transition(AnyTransition.move(edge: .bottom))
                    .animation(Animation.easeInOut)
            }

        } .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            let db = Firestore.firestore()
            do{
                try db.collection("userSettings").document(userData.userID).setData(from: userData)
            }
            catch{
                print("Failed saving to Firebase")
            }
        }
      
        

}

    func loadDefaults(for userID:String, completion:() -> ()){
        let db = Firestore.firestore()
        let ref = db.collection("userSettings").document(userID)
        ref.addSnapshotListener{snapshot, error in
                let result = Result {
                    try snapshot!.data(as: UserData.self)
                }
                switch result {
                    case .success(let remoteUserData):
                        if let remoteUserData = remoteUserData {
                            UserData.shared = remoteUserData
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }


        }
    }
    func checkAuth(){
//            Auth.auth().addStateDidChangeListener { (auth, user) in
//                if user?.email == nil {
//                    print("none")
//
//                    self.viewRouter.currentView = .login
//
//                }
//
//            }
        if Auth.auth().currentUser?.email == nil{
            print("nil")
            self.viewRouter.currentView = .registration
        }
        else{
            loadDefaults(for: Auth.auth().currentUser!.uid){
                print(userData.isOnboardingCompleted)
          
                    if userData.isOnboardingCompleted{
                        self.viewRouter.currentView = .home
                    }
                    else{
                        self.viewRouter.showTabBar = false
                        self.viewRouter.currentView = .introView
                    }
            }
          
          
       
        }
        self.hasCheckedAuth = true
        
         
    }

    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
