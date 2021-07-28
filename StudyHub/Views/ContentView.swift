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
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter:ViewRouter
    @State private var hasCheckedAuth = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showSheet = false
    @State var myGroups = [Groups]()
    @State var myMentors = [Groups]()
    @State var hasIntroed = false
    @State var isIntroducing = false
    @State var settings = false
    @State var add = false
    @State var recentPeople = [Groups]()
    @State var recommendGroups = [Groups]()
    @State var images = [UIImage]()
    @State var user = [User]()
    @State private var offset = CGSize.zero
    @State var hasLoaded: Bool = false
    @State var interests = [String]()
    @State var i = 0
    @State var i2 = -1
    @State var timerLog = [TimerLog]()
  
    @State var interestSelected: [UserInterestTypes] = []
    @State var devChats = [Groups]()
    
    @State var width: CGFloat = 0.0
    var body: some View {
       
            ZStack {
            
        ZStack { 
            Color("Background")
                .edgesIgnoringSafeArea(.all)
                
            LinearGradient(gradient: Gradient(colors: [Color("Primary"), Color("Secondary")]), startPoint: .top, endPoint: .bottomLeading)
                .ignoresSafeArea()
            Image("logo")
                .resizable()
                .scaledToFit()
                .padding(100)
            
                .onAppear{
                   
                    self.checkAuth()
                    self.firstLaunchAction()
                    userData.uses += 1
                    userData.uses = 2
                  
            }
                if hasCheckedAuth {
                    Color("Background")
                        .edgesIgnoringSafeArea(.all)
                        .onAppear{
                            
                            self.loadDevChatsData(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.devChats = userData ?? []
                        }
                            self.loadDMsData(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.recentPeople = userData ?? []
                                
        

                               
                                
                            }
                            
                            
                            self.loadUserTimerLog(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.timerLog = userData 
                                
        

                               
                            }
                           
                            self.loadUserData(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.user = userData
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    hasLoaded = true
                                }
                                self.loadMyGroupsData(){ userData in
                                    myGroups = userData ?? []
                                    self.loadMyMentorsData(){ userData in
                                        myMentors = userData ?? []
                                        
                                self.loadGroupsData(){ userData in
                                    //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                    recommendGroups = userData ?? []
                                   // self.recommendGroups = userData!.removeDuplicates()
                                    let g = recommendGroups + myGroups
                                  recommendGroups = g.removeDuplicates()
                                   
                                  
                                    hasLoaded = true
                                }
                                }
                            }

                            }
                           
                    }
               
                        if hasLoaded {
                            ContentViewSubviews(userData: userData, viewRouter: viewRouter, myGroups: $myGroups, myMentors: $myMentors,  recentPeople: $recentPeople, images: $images, user: $user, interests: $interests, timerLog: $timerLog, interestSelected: $interestSelected, devChats: $devChats)

                    }
                       
                        
                        
                    
                    }
           
         
            // == true || viewRouter.currentView != .registration || viewRouter.currentView != .login 
           
                
        }
        
     //   .preferredColorScheme((userData.darkModeOn==true) ? .dark : .light)
        
        
                if viewRouter.showTabBar {
                    VStack {
                        Spacer()
                        HStack {
                        tabBarView(viewRouter: viewRouter)
                            .transition(AnyTransition.move(edge: .bottom))
                            .animation(Animation.easeInOut(duration: 0.5))
                            
                            if UIDevice.current.userInterfaceIdiom == .pad && viewRouter.currentView == .chatList {
                                Spacer()
                            }
                        }
                    } .transition(AnyTransition.move(edge: .bottom))
                    .animation(Animation.easeInOut(duration: 0.5))
                    .ignoresSafeArea(.all, edges: .bottom)
                }
        

}
    }

    func loadDevChatsData(performAction: @escaping ([Groups]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("devChat")
        var groupList:[Groups] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        queryParameter.addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
            for document in querySnapshot.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let group):
                        if var group = group {
                            i = 0
                            var array = group.groupName.components(separatedBy: " and ")
                            for a in array {
                                if a == userData.name {
                                    print(i)
                                    if i < array.count {
                                    array.remove(at: i)
                                }
                                }
                                i += 1
                            }
                            group.groupName = array.joined()
                            groupList.append(group)
                            
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                
              
            }
            }
            else{
                performAction(nil)
            }
              performAction(groupList)
        }
        
        
    }


    func loadUserData(performAction: @escaping ([User]) -> Void) {
        let db = Firestore.firestore()
     let docRef = db.collection("users").document(self.userData.userID)
        var userList:[User] = []
        //Get every single document under collection users
    
     docRef.addSnapshotListener{ (document, error) in
         
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
   
    func loadMyMentorsData(performAction: @escaping ([Groups]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("mentorships")
        var groupList:[Groups] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        queryParameter.addSnapshotListener(){ (querySnapshot, error) in
            if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
            for document in querySnapshot.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let group):
                        if var group = group {
                            i = 0
                            var array = group.groupName.components(separatedBy: " and ")
                            for a in array {
                                if a == userData.name {
                                    print(i)
                                    if i < array.count {
                                    array.remove(at: i)
                                }
                                }
                                i += 1
                            }
                            group.groupName = array.joined()
                            groupList.append(group)
                            
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                
              
            }
            }
            else{
                performAction(nil)
            }
              performAction(groupList)
        }
        
        
    }
    func loadMyGroupsData(performAction: @escaping ([Groups]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        var groupList:[Groups] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        queryParameter.addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
            for document in querySnapshot.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let group):
                        if var group = group {
                            i = 0
                            var array = group.groupName.components(separatedBy: " and ")
                            for a in array {
                                if a == userData.name {
                                    print(i)
                                    if i < array.count {
                                    array.remove(at: i)
                                }
                                }
                                i += 1
                            }
                            group.groupName = array.joined()
                            groupList.append(group)
                            
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                
              
            }
            }
            else{
                performAction(nil)
            }
              performAction(groupList)
        }
        
        
    }
    func loadDMsData(performAction: @escaping ([Groups]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("dms")
        var groupList:[Groups] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        queryParameter.addSnapshotListener { (querySnapshot, error) in
            if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
            for document in querySnapshot.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let group):
                        if var group = group {
                            i = 0
                            var array = group.groupName.components(separatedBy: " and ")
                            for a in array {
                                if a == userData.name {
                                    print(i)
                                    if i < array.count {
                                    array.remove(at: i)
                                }
                                }
                                i += 1
                            }
                            group.groupName = array.joined()
                            groupList.append(group)
                            
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                
              
            }
            }
            else{
                performAction(nil)
            }
              performAction(groupList)
        }
        
        
    }
    
    func loadUserTimerLog(performAction: @escaping ([TimerLog]) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("timerLog").whereField("userID", isEqualTo: userData.userID)
        var userList:[TimerLog] = []
        //Get every single document under collection users
    
     docRef.addSnapshotListener { (document, error) in
        if let document = document, !document.isEmpty {
        for document in document.documents {
                let result = Result {
                 try document.data(as: TimerLog.self)
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
     }
    }
    func loadGroupsData(performAction: @escaping ([Groups]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        var groupList:[Groups] = []
        if user.isEmpty {
            
        } else {
            guard let interests = user[0].interests else { return }
            if interests.count > 0 {
                //Get every single document under collection users
                
                let queryParameter = docRef.whereField("interests", arrayContains: "\(user[0].interests!.first!)")
                queryParameter.addSnapshotListener { (querySnapshot, error) in
                    if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
                        for document in querySnapshot.documents{
                            let result = Result {
                                try document.data(as: Groups.self)
                            }
                            switch result {
                            case .success(let group):
                                if var group = group {
                                    
                                    
                                    
                                    
                                    
                                    
                                    //                        if user.isAvailable == true {
                                    if myGroups.contains(group) {
                                        
                                    } else {
                                        if group.members.count < 4 {
                                            groupList.append(group)
                                        }
                                    }
                                    //                        }
                                    
                                    
                                    
                                } else {
                                    
                                    print("Document does not exist")
                                }
                            case .failure(let error):
                                print("Error decoding user: \(error)")
                            }
                            
                            
                        }
                    }
                    else{
                        performAction(nil)
                    }
                    performAction(groupList)
                }
            }
        }
    }
    
    func checkPreviousPairing(from myGroups: [Groups], withUser pairedUser: String, for interest: UserInterestTypes) -> Bool {
        var pairedInterests: [UserInterestTypes: [String]] = [.SAT: [], .Algebra1 : [], .Algebra2: [], .Chemistry: [], .Biology: [],.Physics: [], .Spanish: [], .CS: [], .CollegeApps: [], .Other: []]
        for group in myGroups {
            for interest in group.interests {
                guard let interest = interest else { return false }
                var membersWithSameInterest: [String] = []
                for member in group.members {
                    membersWithSameInterest.append(member)
                }
                for member in membersWithSameInterest {
                    pairedInterests[interest]?.append(member)
                }
            }
        }
        guard let currentInterestPairings = pairedInterests[interest] else { return false }
        return currentInterestPairings.contains(pairedUser)
    }
    func downloadImages() {
        for people in myGroups {
            print(0)
            for members in people.members {
                if members != userData.userID {
                print(1)
           
                
            
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: members)
       
       // gs://study-hub-7540b.appspot.com/images
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 1 * 5000 * 5000) { data, error in
          if let error = error {
            print(error)
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            var image = UIImage(data: data!)
            images.append(image!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            //showLoadingAnimation = false
            }
          }
        }
        }
            }
        }
        
    }
    func checkAuth(){

            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil{
                    if userData.isOnboardingCompleted {
                        withAnimation(.easeOut(duration: 1.0)) {
                        self.viewRouter.currentView = .home
                        }
                    }
                    else{
                        self.viewRouter.showTabBar = false
                        self.viewRouter.currentView = .custom
                    }
                    self.hasCheckedAuth = true

                
                }
                else {
                    withAnimation(.easeInOut(duration: 1.5)) {
                    self.viewRouter.currentView = .introView
                    self.hasCheckedAuth = true
                }
                }
            }
        
         
    }
    
    func firstLaunchAction() {
        let firstLaunch = userData.firstRun
        if firstLaunch {
            FirebaseManager.signOut()
            userData.firstRun = false
        }
    }
    

}



