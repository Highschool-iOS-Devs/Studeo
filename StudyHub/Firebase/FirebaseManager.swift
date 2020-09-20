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
    
    let db = Firestore.firestore()
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
    
    

}
