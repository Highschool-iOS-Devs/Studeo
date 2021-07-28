//
//  FirebaseManager.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct FirebaseManager{
    
    static let db = Firestore.firestore()
    public static func setData(){
        
    }
    public static func signOut(){
        do{
           try Auth.auth().signOut()
        }
        catch{
            print("Error signing out user, \(error)")
        }
    }
    
    public static func updateEmail( _ newEmail: String) {
        let currentUser = Auth.auth().currentUser
        
        currentUser?.updateEmail(to: newEmail, completion: { (error) in
            if let error = error {
                // show error
                print(error.localizedDescription)
            } else {
                print("Successfully updated email")
                // update the email everywhere
                let refDB = Firestore.firestore()
                refDB.collection("users").document(UserData.shared.userID).setData(["email" : newEmail], merge: true)
            }
        })
    }
    
    public static func forgotPassword() {
        
        let email: String? = Auth.auth().currentUser?.email ?? nil
                
        if email != nil {
            
            Auth.auth().sendPasswordReset(withEmail: email!) { (error) in
                if error != nil {
                    // show error
                    return
                }
                
                print("Successfully sent password rest email!")
                // show success popup here?
                
            }
            
        } else {
            // show error
        }
    }
    
    public static func deleteUser(userID: String, completion: @escaping (Error?) -> Void) {
        let settingsRef = db.collection("settings").document(userID)
        let usersRef = db.collection("users").document(userID)
        leaveAllGroups(userID: userID) { error in
            guard error == nil else {
                completion(error)
                return
            }
            settingsRef.delete { error in
                guard error == nil else {
                    completion(error)
                    return
                }
                usersRef.delete { error in
                    guard error == nil else {
                        completion(error)
                        return
                    }
                    Auth.auth().currentUser?.delete(completion: { error in
                        completion(error)
                    })
                }
            }
        }
        
    }
    
    public static func leaveGroup(groupID: String, userID: String, completion: @escaping (Error?) -> Void) {
        let groupsRef = db.collection("groups").document(groupID)
        let userRef = db.collection("users").document(userID)
        userRef.updateData(["recentGroups": FieldValue.arrayRemove([groupID])]) { error in
            if let error = error {
                completion(error)
            } else {
                userRef.updateData(["groups": FieldValue.arrayRemove([groupID])]) { error in
                    if let error = error {
                        completion(error)
                    } else {
                        groupsRef.updateData(["members": FieldValue.arrayRemove([userID])]) { error in
                            completion(error)
                        }
                    }
                }
            }
        }
    }
    
    public static func leaveAllGroups(userID: String, completion: @escaping (Error?) -> Void) {
        let groupsRef = db.collection("groups").whereField("members", arrayContains: userID)
        let mentorshipsRef = db.collection("mentorships").whereField("members", arrayContains: userID)
        let dmsRef = db.collection("dms").whereField("members", arrayContains: userID)
        groupsRef.getDocuments { snapshot, error in
            if let snapshot = snapshot, !snapshot.isEmpty {
                for document in snapshot.documents {
                    db.collection("groups").document(document.documentID).updateData(["members": FieldValue.arrayRemove([userID])]) { error in
                        if let error = error {
                            completion(error)
                        } else {
                            mentorshipsRef.getDocuments { snapshot, error in
                                if let snapshot = snapshot {
                                    for document in snapshot.documents {
                                        db.collection("mentorships").document(document.documentID).updateData(["members": FieldValue.arrayRemove([userID])]) { error in
                                            if let error = error {
                                                completion(error)
                                            } else {
                                                dmsRef.getDocuments { snapshot, error in
                                                    if let snapshot = snapshot {
                                                        for document in snapshot.documents {
                                                            db.collection("dms").document(document.documentID).updateData(["members": FieldValue.arrayRemove([userID])]) { error in
                                                                completion(error)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                mentorshipsRef.getDocuments { snapshot, error in
                    if let snapshot = snapshot, !snapshot.isEmpty {
                        for document in snapshot.documents {
                            db.collection("mentorships").document(document.documentID).updateData(["members": FieldValue.arrayRemove([userID])]) { error in
                                if let error = error {
                                    completion(error)
                                } else {
                                    dmsRef.getDocuments { snapshot, error in
                                        if let snapshot = snapshot {
                                            for document in snapshot.documents {
                                                db.collection("dms").document(document.documentID).updateData(["members": FieldValue.arrayRemove([userID])]) { error in
                                                    completion(error)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        dmsRef.getDocuments { snapshot, error in
                            if let snapshot = snapshot, !snapshot.isEmpty {
                                for document in snapshot.documents {
                                    db.collection("dms").document(document.documentID).updateData(["members": FieldValue.arrayRemove([userID])]) { error in
                                        completion(error)
                                    }
                                }
                            } else {
                                completion(error)
                            }
                        }
                    }
                }
            }
        }
    }
    
    

}
