//
//  ChatViewModel.swift
//  StudyHub
//
//  Created by Jevon Mao on 1/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatViewModel:ObservableObject{
    var userData:UserData?
    @Published var allGroups:[Groups] = []
    @Published var allUnjoinedGroups:[Groups] = []
    @Published var allUnjoinedMentors:[Groups] = []
    @Published var recentGroups:[Groups] = []
    @Published var recentPeople:[User] = []
    @Published var currentUser:User?
    
    func getAllUnJoinedGroups(performAction: @escaping ([Groups]) -> Void){
        guard userData != nil else {return}
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        let queryParameter = docRef
        var allGroups:[Groups] = []

        queryParameter.getDocuments{ (querySnapshot, error) in
            guard querySnapshot != nil else {
                print("Empty snapshot")
                return}
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            if !user.members.contains(self.userData!.userID) {
                                if user.members.count < 6 {
                            allGroups.append(user)
                                }
                            }
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
            }
            performAction(allGroups)
        }
    }
    
    func getAllUnJoinedmentors(performAction: @escaping ([Groups]) -> Void){
        guard userData != nil else {return}
        let db = Firestore.firestore()
        let docRef = db.collection("users").whereField("isMentor", isEqualTo: true).whereField("id", isNotEqualTo: userData?.userID)
        let queryParameter = docRef
        var allGroups:[Groups] = []

        queryParameter.getDocuments{ [self] (querySnapshot, error) in
            guard querySnapshot != nil else {
                print("Empty snapshot")
                return}
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            let interests =  user.mentorshipInterests?.filter { (string) -> Bool in
                                return currentUser?.interests?.contains(string) ?? false
                            }
                            allGroups.append(Groups(id: UUID().uuidString, groupID: UUID().uuidString, groupName: user.name + " " + (interests?.first?.rawValue ?? ""), members: [user.id.uuidString, userData?.userID ?? ""], membersCount: 1, interests: interests ?? [.Algebra1]))
                            print(allGroups.last)
                              
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
            }
            performAction(allGroups)
        }
    }
    
    func getAllGroups(performAction: @escaping ([Groups]) -> Void){
        guard userData != nil else {return}
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        let queryParameter = docRef.whereField("members", arrayContains: userData!.userID)
        var allGroups:[Groups] = []

        queryParameter.getDocuments{ (querySnapshot, error) in
            guard querySnapshot != nil else {
                print("Empty snapshot")
                return}
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            if !allGroups.contains(user){
                                allGroups.append(user)
                            }

                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
            }
            performAction(allGroups)
        }
    }
    func getRecentGroups(performAction: @escaping ([Groups]) -> Void){
        var recentGroups:[Groups] = []
        getCurrentOrAnyUser(){user in
            if let groups = user.recentGroups{
                for id in groups{
                    self.getGroups(groupID: id){group in
                        if !recentGroups.contains(group){
                            recentGroups.append(group)
                        }
                        
                        performAction(recentGroups)
                    }
                }
            }
        }
    }
    func getRecentPeople() -> [User]{
        var recentPeople:[User] = []
        getCurrentOrAnyUser(){user in
            self.currentUser = user
            if let people = user.recentPeople{
                for id in people{
                    self.getCurrentOrAnyUser(userID: id){user in
                        recentPeople.append(user)
                    }
                  
                }
            }
        }
        return recentPeople
    }

    func getCurrentOrAnyUser(userID: String?=nil, performAction: @escaping (User) -> Void){
        guard userData != nil else {return}

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID ?? userData!.userID)
        docRef.addSnapshotListener{document, error in
            let result = Result{
                try document?.data(as: User.self)
            }
            switch result{
            case .success(let user):
                if let user=user{
                    performAction(user)
                }
                else{
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding group: \(error)")
            }

        }
    }

    func getGroups(groupID:String, performAction: @escaping (Groups) -> Void){
        let db = Firestore.firestore()
        let ref = db.collection("groups").document(groupID)
        ref.addSnapshotListener{ (document, error) in
                let result = Result {
                    try document?.data(as: Groups.self)
                }
                switch result {
                    case .success(let group):
                        if let group = group {
                            performAction(group)

                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
        }
     
    }

}
