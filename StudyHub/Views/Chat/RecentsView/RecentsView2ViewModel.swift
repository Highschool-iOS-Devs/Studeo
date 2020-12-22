//
//  RecentsView2ViewModel.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/21/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecentsView2ViewModel: ObservableObject{
    var group:Groups?
    public static let shared = RecentsView2ViewModel()
    @Published var profileImages:[URL]=[]

    func getProfileImages(){
        ///Firebase networking to fetch images
        if profileImages == []{
            if let group = group{
                for member in group.members{
                    let metadata = StorageMetadata()
                    metadata.contentType = "image/jpeg"
                    let storage = Storage.storage().reference().child("User_Profile/\(member)")
                    storage.downloadURL{url, error in
                        if let error = error{
                            print("Error downloading image, \(error)")
                        }
                        self.profileImages.append(url!)
                    }
                }
            }
        }
   
   
    }
    
    func setGroup(group:Groups){
        self.group = group
    }
    
}
