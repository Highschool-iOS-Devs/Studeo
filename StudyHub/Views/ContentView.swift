//
//  ContentView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @State private var hasCheckedAuth = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showSheet = false
    @State var myGroups = [Groups]()
    @State var hasIntroed = false
    @State var isIntroducing = false
    @State var settings = false
    @State var add = false
    @State var recentPeople = [Groups]()
    @State var profileImage = UIImage()
    @State var user = [User]()
    var body: some View {
        ZStack { 
            Color.white
                .edgesIgnoringSafeArea(.all)
                .onAppear{
                    self.checkAuth()
                   
            }
           
                if hasCheckedAuth {
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                        .onAppear{
                            
                            self.loadData(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.myGroups = userData
                                
                            }
                            downloadImage()
                            self.loadData2(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.user = userData
                            
                            
                            }
                    }
                if viewRouter.currentView == .registration{
                    RegistrationView()
                        .environmentObject(viewRouter)
                }
                else if viewRouter.currentView == .login {
                    LoginView()
                        .environmentObject(viewRouter)
                }
                else if viewRouter.currentView == .chatList {
                    RecentsView2(recentPeople: myGroups)
                        .environmentObject(userData)
                        .environmentObject(viewRouter)
                }
                else if viewRouter.currentView == .profile {
                    ProfileView(profileImage: $profileImage, user: $user)
                        .environmentObject(userData)
                        .environmentObject(viewRouter)
                }
               
                else if viewRouter.currentView == .leaderboard {
                    LeaderboardView()
                        .environmentObject(userData)
                        .environmentObject(viewRouter)
                }
                else if viewRouter.currentView == .home {
                    Home()
                        .environmentObject(userData)
                        .environmentObject(viewRouter)
                      
                        
                }
                else if viewRouter.currentView == .settings{
                    SettingView()
                        .environmentObject(viewRouter)
                        .environmentObject(userData)
                }
                else if viewRouter.currentView == .introView{
                    IntroView()
                        .environmentObject(viewRouter)
                        .environmentObject(userData)
                }
            
            
            
            // == true || viewRouter.currentView != .registration || viewRouter.currentView != .login 
            if viewRouter.showTabBar {
                VStack{
                    Spacer()
                    tabBarView()
                        
                }.transition(AnyTransition.move(edge: .bottom))
                    .animation(Animation.easeInOut)
            }
                }
         
        }
        

}
    func downloadImage() {
   
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: userData.userID)
       
       // gs://study-hub-7540b.appspot.com/images
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 1 * 5000 * 5000) { data, error in
          if let error = error {
            print(error)
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            var image = UIImage(data: data!)
            profileImage = image!
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            //showLoadingAnimation = false
            }
          }
        }
        
        
        
    }
    
    func loadData2(performAction: @escaping ([User]) -> Void) {
        let db = Firestore.firestore()
     let docRef = db.collection("users").document(self.userData.userID)
        var userList:[User] = []
        //Get every single document under collection users
    
     docRef.getDocument{ (document, error) in
         
                let result = Result {
                 try document?.data(as: User.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            userList.append(user)
                 
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                
              
            
              performAction(userList)
        }
    }
    
    func loadData(performAction: @escaping ([Groups]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        var userList:[Groups] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        queryParameter.getDocuments{ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            userList.append(user)
                 
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                
              
            }
              performAction(userList)
        }
        
        
    }
    func checkAuth(){
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil{
                    if userData.isOnboardingCompleted{

                        self.viewRouter.currentView = .home
                    }
                    else{
                        self.viewRouter.showTabBar = false
                        self.viewRouter.currentView = .introView
                    }
                    self.hasCheckedAuth = true

                
                }
                else {
                    self.viewRouter.currentView = .registration
                    self.hasCheckedAuth = true
                }
               
            }
        
         
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
