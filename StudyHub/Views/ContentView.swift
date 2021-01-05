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
    @State var show = true
    @State var timerLog = [TimerLog]()
    @State var quizzes = [Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question]())]
    @State var quiz = Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question]())
    @State var devGroup = Groups(id: "", groupID: UUID().uuidString, groupName: "Andreas", members: [String](), membersCount: 0, interests: [UserInterestTypes?](), recentMessage: "", recentMessageTime: Date(), userInVC: [String]())
    var body: some View {
        GeometryReader { geo in
        ZStack { 
            Color("Background")
                .edgesIgnoringSafeArea(.all)
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
                            self.loadDMsData(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.recentPeople = userData ?? []
                                
        

                               
                            }
                            self.loadUserTimerLog(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                                self.timerLog = userData 
                                
        

                               
                            }
                            self.loadQuizzes(){ userData in
                                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                              //  self.quizzes = userData ?? []
                                
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
                    VStack {
                        if hasLoaded {
                            switch viewRouter.currentView {
                            case .devChat:
                                ChatView(group: devGroup, show: $show)
                                    .onAppear() {
                                        viewRouter.showTabBar = false
                                        
                                        
                                        userData.hasDev = true
                                    }
                            case .mentor:
                                MentorPairingView(settings: $settings, add: $add, myGroups: $myGroups, myMentors: $myMentors)
                            case .registration:
                                RegistrationView()
                            .environmentObject(viewRouter)
                    case .login:
                        LoginView()
                       
                    case .chatList:
                        RecentsView2(myMentors: $myMentors, timerLog: $timerLog)
                            .environmentObject(userData)
                            .environmentObject(viewRouter)
                    case .profile:
                        ProfileView(user: $user)
                            .environmentObject(userData)
                            .environmentObject(viewRouter)
                    case .home:
                        if userData.uses == 1 {
                            Homev2(recentPeople: $recentPeople, recommendGroups: $recommendGroups, user: $user, timerLog: $timerLog, devGroup: $devGroup)
                               
                                .onAppear() {
                                    viewRouter.showTabBar = true
                                }
                        } else {
                            //Home(timerLog: $timerLog)
                            Homev2(recentPeople: $recentPeople, recommendGroups: $recommendGroups, user: $user, timerLog: $timerLog, devGroup: $devGroup)
                                                                .onAppear() {
                                    viewRouter.showTabBar = true
                                }
                            .environmentObject(userData)
                            .environmentObject(viewRouter)

                       
                        }
                    case .custom:
                        IntroCustomize(isNotOnboarding: true, interests: $interests, settings: $settings, add: $add)
                            .onDisappear() {
                                viewRouter.showTabBar = true
                            }
                    case .settings:
                        SettingView()
                            .environmentObject(viewRouter)
                            .environmentObject(userData)
                    case .leaderboard:
                        LeaderboardView()
                            .environmentObject(userData)
                            .environmentObject(viewRouter)
                    case .introView:
                        IntroView()
                            .transition(.opacity)
                            .animation(.easeInOut)
                            .onAppear() {
                                viewRouter.showTabBar = false
                            }
                            
                    case .quizList:
                        QuizzesList(quizzes: quizzes)
                    }

                    }
                       
                        
                        }
                    
                    }
            if viewRouter.showTabBar {
                VStack {
                    Spacer()
                    tabBarView()
                        .transition(AnyTransition.move(edge: .bottom))
                        .animation(Animation.easeInOut(duration: 0.5))
                        .frame(height: geo.size.height/20)
                } .transition(AnyTransition.move(edge: .bottom))
                .animation(Animation.easeInOut(duration: 0.5))
            }
         
            // == true || viewRouter.currentView != .registration || viewRouter.currentView != .login 
           
                
        }
        .frame(height: geo.size.height)
        .preferredColorScheme((userData.darkModeOn==true) ? .dark : .light)
        }
        .environmentObject(userData)
        .environmentObject(viewRouter)
        

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
    func loadQuizzes(performAction: @escaping ([Quiz]?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("quizzes/questions/\(quiz.id)")
        var groupList:[Quiz] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        docRef.addSnapshotListener{ (querySnapshot, error) in
            if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
            for document in querySnapshot.documents{
                let result = Result {
                    try document.data(as: Quiz.self)
                }
                switch result {
                    case .success(let group):
                        if var group = group {
                          
                          
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
        var pairedInterests: [UserInterestTypes: [String]] = [.ACT: [], .APCalculus : [], .SAT: [], .Algebra2: []]
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



