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
    @State var matchedPerson = User(id: UUID(), firebaseID: "", name: "", email: "", interests: [], groups: [], isMentor: false, studyHours: [0], studyDate: [""], all: 0, month: 0, day: 0, description: "", isAvailable: true)
    @EnvironmentObject var userData:UserData
    @Environment(\.presentationMode) var presentationMode
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
    var groupModel:ChatViewModel
    var body: some View {
        ZStack {
            Color("Background")
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
                    checkIfExistingGroup{
                        ///If already exist of  a group of correct interest, and it's not full, checkIfExstingGroup() will join user to that group. Otherwise, it will return false
                        if $0 == false{
                            pairUser{newGroup in
                                self.newGroup = newGroup
                                if let group = self.newGroup{
                                        self.addUserGroupRecord(newGroup: group)
                                        paired = true
                                    }
                                    else{
                                        print("Pairing failed.")
                                    }
                            }
                        }
                        else{
                            print("Group of corresponding interest already exist, joined user to that group.")
                        }
                        
                    }
 
            
                }) {
                    Text("Pair")
                        .font(Font.custom("Montserrat-SemiBold", size: 14.0))
                } .buttonStyle(BlueStyle())
                .padding()
                Spacer(minLength: 200)
            }
            
            .sheet(isPresented: self.$paired, onDismiss: {
                self.add = false
            }){
                if let group = newGroup{
                    //ChatView(group: group)
//                        .environmentObject(userData)
                    PairingSuccess(paired: $paired, chat: $chat, group: group)
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
                            .onTapGesture {
                                presentationMode.wrappedValue.dismiss()
                            }
                            .font(.largeTitle)
                        
                        
                        
                    }
                    Spacer()
                }
                Spacer()
            } .padding()
            
            if settings {
                
                IntroCustomize(interestSelected: $selectedInterests, isNotOnboarding: false, interests: $interests, settings: $settings, add: $add, groupModel:groupModel)
                
            }
            if error {
                VStack {
                   
                ErrorMessage(errorObject: ErrorModel(errorMessage: "You've paired with everyone!", errorState: true), displayError: true)
                    Spacer()
                } .padding(.top, 100)
            }
            
        }
        .onAppear{
            loadData()
        }
        .onDisappear {
            saveData()
        }
    }
    
    func addUserGroupRecord(newGroup:Groups) {
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        do{
            try docRef.document(newGroup.groupID).setData(from: newGroup)
            
        }
        catch{
            print("Error writing to database, \(error)")
        }
        
       
        for member in newGroup.members {
        let ref2 = db.collection("users").document(member)
        ref2.getDocument{document, error in
            
            if let document = document, document.exists {
                
         
                let groupListCast = document.data()?["groups"] as? [String]
                
                if var currentGroups = groupListCast{
                    
                    guard !(groupListCast?.contains(newGroup.groupID))! else{return}
                    currentGroups.append(newGroup.groupID)
                    ref2.updateData(
                        [
                            "groups":currentGroups
                        ]
                    )
                } else {
                    ref2.updateData(
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
    }
    
    func joinExistingGroup(groupID:String){
        let db = Firestore.firestore()
        let ref = db.collection("groups").document(groupID)
        ref.updateData([
            "members" : FieldValue.arrayUnion([userData.userID]),
            "membersCount" : FieldValue.increment(Int64(1))
        ])
        let ref2 = db.collection("users").document(userData.userID)
        ref2.updateData([
            "groups":FieldValue.arrayUnion([groupID])
        ])
    }
    
    func loadData(){
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

                }
          
            
        }
    
    func saveData() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(self.userData.userID)
        do {
            try docRef.setData(from: ["interests": interests], merge: true)
            docRef.updateData(["finishedOnboarding": true]) { error in
                if let error = error {
                    print("Error updating data: \(error)")
                }
            }
        } catch let error {
            print(error)
        }
        
    }
    
    func checkIfExistingGroup(completion: @escaping (Bool) -> Void){
        var interests = selectedInterests
        let allUserGroups = groupModel.allGroups
        for group in allUserGroups{
            
            if interests.contains(group.interests[0]!){
                let interestIndex = interests.firstIndex(of: group.interests[0]!)!
                interests.remove(at: interestIndex)
            }
        }
        let rawValueInterests = interests.map{$0.rawValue}
        guard rawValueInterests != [] else { error=true;return}

        let db = Firestore.firestore()
        let queryRef = db.collection("groups").whereField("interests", arrayContainsAny: rawValueInterests).whereField("membersCount", isLessThanOrEqualTo: 5).order(by: "membersCount", descending: false)
        queryRef.getDocuments{snapshot, error in
            guard error == nil else {
                print("Error query matching interests, \(error!)")
                return
            }
            if snapshot!.documents.count > 0{
                completion(true)
                let document = snapshot!.documents[0]
                let result = Result{
                    try document.data(as: Groups.self)
                }
                switch result {
                case .success(let group):
                    if let group = group {
                        joinExistingGroup(groupID: group.groupID)
                    }
                case .failure(let error):
                    print("Error decoding pairing data, \(error)")

                }
                
            }
            else{
                completion(false)
            }
        }
    

    }
    func pairUser(completion: @escaping (Groups) -> Void){
        let db = Firestore.firestore()
        
        var interests = selectedInterests
        let allUserGroups = groupModel.allGroups
        for group in allUserGroups{
            
            if interests.contains(group.interests[0]!){
                let interestIndex = interests.firstIndex(of: group.interests[0]!)!
                interests.remove(at: interestIndex)
            }
        }
        let rawValueInterests = interests.map{$0.rawValue}
        guard rawValueInterests != [] else { error=true; return}
        let queryRef = db.collection("users").whereField("interests", arrayContainsAny: rawValueInterests).whereField("id", isNotEqualTo: userData.userID)
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
                        //for interest in user.interests ?? [] {
//                            pairedBefore = checkPreviousPairing(from: myGroups, withUser: user.id.uuidString, for: interest)
//                            if pairedBefore == true {
//                                break
//                            }
                        //}
                       // if !pairedBefore {
//                        if user.isAvailable == true {
                        matchedUsers.append(user)
//                        }
                        //}
                    }
                case .failure(let error):
                    print("Error decoding pairing data, \(error)")

                }
            }
                guard matchedUsers.count != 0 else {self.error = true; return}
                var matchedPeople:[User] = []
                if matchedUsers.count > 5{
                    for _ in 0..<4{
                        let randomUser = matchedUsers[Int.random(in: 0..<matchedUsers.count)]
                        matchedPeople.append(randomUser)
                        
                    }
                }
                else{
                    matchedPeople=matchedUsers
                }
                
                    var groupMemberIDs = matchedPeople.map{$0.id.uuidString}
                    groupMemberIDs += [userData.userID]
                    let groupInterest = interests[Int.random(in:0..<interests.count)]
                    let group = Groups(id: UUID().uuidString,
                                      groupID: UUID().uuidString,
                                      groupName: "\(groupInterest) Group",
                                      members: groupMemberIDs,
                                      membersCount: groupMemberIDs.count,
                                      interests: [groupInterest], userInVC: [String]())
                completion(group)
        
            
        }
    }
    
    
    

    
    func checkPreviousPairing(from myGroups: [Groups], withUser pairedUser: String, for interest: UserInterestTypes) -> Bool {
        var pairedInterests = [UserInterestTypes: [String]]()
        UserInterestTypes.allCases.forEach{interest in
            pairedInterests[interest] = []
        }
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
