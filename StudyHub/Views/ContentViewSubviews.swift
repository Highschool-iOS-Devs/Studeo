//
//  ContentViewSubviews.swift
//  StudyHub
//
//  Created by Jevon Mao on 1/7/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct ContentViewSubviews: View {
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter:ViewRouter
    @State private var hasCheckedAuth = false
    @Environment(\.presentationMode) var presentationMode
    @State private var showSheet = false
    @Binding var myGroups: [Groups]
    @Binding var myMentors: [Groups]
    @State var hasIntroed = false
    @State var isIntroducing = false
    @State var settings = false
    @State var add = false
    @Binding var recentPeople: [Groups]
    @State var recommendGroups = [Groups]()
    @Binding var images: [UIImage]
    @Binding var user: [User]
    @State private var offset = CGSize.zero
    @State var hasLoaded: Bool = false
    @Binding var interests: [String]
    @State var i = 0
    @State var i2 = -1
    @Binding var timerLog: [TimerLog]
    @State var show = false
    @State var devGroup = Groups(id: UUID().uuidString, groupID: UUID().uuidString, groupName: "Dev Chat", members: [String](), membersCount: 0, interests: [UserInterestTypes?](), recentMessage: "", recentMessageTime: Date(), userInVC: [String]())
    
    @Binding var interestSelected: [UserInterestTypes]
    @Binding var devChats: [Groups]
    var body: some View {
        switch viewRouter.currentView {
        case .devChat:
            ChatView(userData: userData, viewRouter: viewRouter, group: $devGroup, show: $show, hideNavBar: .constant(false))
                .onAppear() {
                    viewRouter.showTabBar = false
                    
                    
                    userData.hasDev = true
                }
        case .mentor:
            PairingListView(userData: userData, viewRouter: viewRouter, myMentors: $myMentors, timerLog: $timerLog, devChats: $devChats, lookingForMentor: true)
        case .registration:
            RegistrationView(viewRouter: viewRouter, userData: userData)
            
        case .login:
            LoginView(userData: userData, viewRouter: viewRouter)
            
        case .chatList:
            RecentsView2(userData: userData, viewRouter: viewRouter, myMentors: $myMentors, timerLog: $timerLog, devChats: $devChats)
                
                
                .onAppear() {
                    viewRouter.showTabBar = true
                }
        case .profile:
            ProfileView(user: $user, userData: userData, viewRouter: viewRouter)
                
                
                .onAppear() {
                    viewRouter.showTabBar = true
                }
        case .home:
            if userData.uses == 1 {
                Homev2(userData: userData, viewRouter: viewRouter, recentPeople: $recentPeople, recommendGroups: $recommendGroups, user: $user, timerLog: $timerLog, devGroup: $devGroup)
                    
                    .onAppear() {
                        viewRouter.showTabBar = true
                    }
            } else {
                //Home(timerLog: $timerLog)
                Homev2(userData: userData, viewRouter: viewRouter, recentPeople: $recentPeople, recommendGroups: $recommendGroups, user: $user, timerLog: $timerLog, devGroup: $devGroup)
                    
                    .onAppear() {
                        viewRouter.showTabBar = true
                    }
                
                
                
                
            }
        case .custom:
            IntroCustomize(interestSelected: $interestSelected, userData: userData, isNotOnboarding: true, interests: $interests, settings: $settings, add: $add, viewRouter: viewRouter)
                .onAppear {
                    viewRouter.showTabBar = false
                }
                .onDisappear() {
                    viewRouter.showTabBar = true
                }
        case .mentorCustom:
            IntroMentor(userData: userData, viewRouter: viewRouter)
                .onAppear() {
                    viewRouter.showTabBar = false
                }
        case .settings:
            SettingView(userData: userData, viewRouter: viewRouter)
                
                
                .onAppear() {
                    viewRouter.showTabBar = true
                }
        case .leaderboard:
            LeaderboardView(userData: userData)
                
                
                .onAppear() {
                    viewRouter.showTabBar = true
                }
        case .introView:
            IntroView(viewRouter: viewRouter, userData: userData)
                
                .transition(.opacity)
                .animation(.easeInOut)
                .onAppear() {
                    viewRouter.showTabBar = false
                }
            
        case .quizList:
            IntroView(viewRouter: viewRouter, userData: userData)
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


