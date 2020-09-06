//
//  FirebaseManager.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseManager{
    let db = Firestore.firestore()
    func signOut(){
        do{
           try Auth.auth().signOut()
        }
        catch{
            print("Error signing out user, \(error)")
        }
    }

}
