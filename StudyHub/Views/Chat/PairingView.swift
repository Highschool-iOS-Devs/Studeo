//
//  PairingView.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase

struct PairingView: View {
    @State var matchedPerson = User(id: UUID(), firebaseID: "", name: "", email: "", image: "", interests: [], groups: [], studyHours: 0, studyDate: "", all: 0, month: 0, day: 0, description: "", isAvailable: true)
    @State var people = [User]()
    @EnvironmentObject var userData:UserData
    @State var paired: Bool = false
    @Binding var settings: Bool
    @Binding var add: Bool 
    @State var selectedInterests:[UserInterestTypes] = []
    @Binding var myGroups:[Groups]
    @State var colorPick = Color.white
    @State var groupName = ""
    @State var newGroup:Groups?
    @State var interests = [String]()
    @State var num = 0
    @State var error = false
    @State var chat = false
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "gear")
                        .font(.largeTitle)
                        
                        .opacity(0.7)
                        .onTapGesture {
                            settings.toggle()
                        }
                }
                Spacer()
            } .padding()
            .onAppear{
                self.loadData { userData in
                    //Get completion handler data results from loadData function and set it as the recentPeople local variable
                    if let userData = userData{
                        
                        self.people = userData
                    }
                    //                    print(self.people)
                }
            }
            
            VStack {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("3566801")
                            
                            .renderingMode(.original)
                            
                            .resizable()
                            // .frame(width: 350, height: 350)
                            
                            .scaledToFit()
                        Spacer()
                    }
                    Spacer()
                }
                Button(action: {
                    guard people.count != 0 else {self.error = true; return}
                    var matchedPeople:[User] = []
                    for _ in 0..<people.count{
                        if matchedPeople.count < 4{
                            let randomUser = people[Int.random(in: 0..<people.count)]
                            matchedPeople.append(randomUser)
                        }
                    }
                        var groupMemberIDs = matchedPeople.map{$0.id.uuidString}
                        groupMemberIDs += [userData.userID]
                        newGroup = Groups(id: UUID().uuidString,
                                          groupID: UUID().uuidString,
                                          groupName: "\(self.selectedInterests[0]) Group",
                                          members: groupMemberIDs,
                                          interests: self.selectedInterests)
                        if let group = newGroup{
                            self.joinGroup(newGroup: group)
                            paired = true
                        }
                        else{
                            print("Pairing failed.")
                        }
                        //                        people.removeAll()
                        //                        self.loadData(){ userData in
                        //                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                        //                            self.people = userData
                        //
                        //                        }
                        
                        
             
                    
                }) {
                    Text("Pair")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                } .buttonStyle(BlueStyle())
                .padding()
                Spacer(minLength: 150)
            }
            
            .sheet(isPresented: self.$paired, onDismiss: {
                self.add = false
            }){
                if let group = newGroup{
                    ChatView(group: group, chat: $chat)
                        .environmentObject(userData)
                }
               
            }
            
            VStack {
                HStack {
                    Button(action: {
                        
                        if !settings {
                            add = false
                        }
                        if settings {
                            settings = false
                        }
                        
                        
                    }) {
                        Image(systemName: "xmark")
                            .font(.largeTitle)
                        
                        
                        
                    }
                    Spacer()
                }
                Spacer()
            } .padding()
            
            if settings {
                
                IntroCustomize(isNotOnboarding: false, interests: $interests, settings: $settings, add: $add)
                
            }
            if error {
                VStack {
                   
                ErrorMessage(errorObject: ErrorModel(errorMessage: "You've paired with everyone!", errorState: true), displayError: true)
                    Spacer()
                } .padding(.top, 100)
            }
            
        }
    }
    
    func joinGroup(newGroup:Groups){
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        do{
            try docRef.document(newGroup.groupID).setData(from: newGroup)
            
        }
        catch{
            print("Error writing to database, \(error)")
        }
        
        let ref = db.collection("users").document(self.userData.userID)
        ref.getDocument{document, error in
            
            if let document = document, document.exists {
                
         
                let groupListCast = document.data()?["groups"] as? [String]
                
                if var currentGroups = groupListCast{
                    
                    guard !(groupListCast?.contains(newGroup.groupID))! else{return}
                    currentGroups.append(newGroup.groupID)
                    ref.updateData(
                        [
                            "groups":currentGroups
                        ]
                    )
                } else {
                    ref.updateData(
                        [
                            "groups":[newGroup.groupID]
                        ]
                    )
                }
            } else {
                print("Error getting user data, \(error!)")
            }
        }
    }
    
    func loadData(performAction: @escaping ([User]?) -> Void){
    

    let db = Firestore.firestore()
    let ref = db.collection("users").document(self.userData.userID)
    var currentUserInterests:[String] = []
    
    ref.getDocument{document, error in
        let result = Result{
            try document?.data(as: User.self)
        }
        switch result{
        case .success(let user):
            if let user = user{
                for interest in user.interests ?? []{
                    currentUserInterests.append(interest.rawValue)
                    selectedInterests.append(interest)
                }
            }
            else{
                print("Document does not exist.")
            }
        case .failure(let error):
            print("Error decoding user data, \(error)")
        }
        let queryRef = db.collection("users").whereField("interests", arrayContainsAny: currentUserInterests).whereField("id", isNotEqualTo: userData.userID)
        queryRef.getDocuments{ snapshot, error in
            guard error == nil else {
                print("Error query matching interests, \(error!)")
                return
            }
            var matchedUsers = [User]()
            for document in snapshot!.documents {
                let result = Result{
                    try document.data(as: User.self)
                }
                switch result {
                case .success(let user):
                    if let user = user {
                        var pairedBefore = false
                        for interest in user.interests ?? [] {
                            pairedBefore = checkPreviousPairing(from: myGroups, withUser: user.id.uuidString, for: interest)
                            if pairedBefore == true {
                                break
                            }
                        }
                        if !pairedBefore {
//                        if user.isAvailable == true {
                        matchedUsers.append(user)
//                        }
                        }
                    }
                case .failure(let error):
                    print("Error decoding pairing data, \(error)")

                }
            }
            performAction(matchedUsers)
            
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
}
