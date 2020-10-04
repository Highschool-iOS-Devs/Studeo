//
//  UserData.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
//

import Foundation
import SwiftUI
import Combine
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseCore

struct User: Identifiable, Codable {
    var id: UUID
    var firebaseID: String
    var name: String
    var email: String
    var image: String?
    var interests: [String]?
    var groups: [String]?
    var recentPepole: [User]?
    var studyHours: Double
    var studyDate: String
    var all: Double
    var month: Double
    var day: Double
    var description: String
}

struct BasicUser: Identifiable, Codable {
    var id: String
    var name: String
   
    init(id: String, name: String) {
        self.id = id
        self.name = name
       
    }
}


//@propertyWrapper
//struct FirebaseSettingData<T> {
//    let value: T
//
//    init(value: T) {
//        self.value = value
//    }
//
//    var wrappedValue: T {
//        get {
//            let db = Firestore.firestore()
//            let docRef = db.collection("userSettings").document()
//            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
//        }
//        set {
//            UserDefaults.standard.set(newValue, forKey: key)
//        }
//    }
//}

final class UserData: ObservableObject, Codable {
    
    
    public static var shared = UserData()
    
    enum CodingKeys:CodingKey{
        case isOnboardingCompleted
        case name
        case userID
        case country
        case language
        case description
        case chatNotificationsOn
        case joinedGroupNotificationsOn
    }
    init(){}
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isOnboardingCompleted = try container.decode(Bool.self, forKey: .name)
        name = try container.decode(String.self, forKey: .name)
        userID = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .name)
        language = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .name)
        chatNotificationsOn = try container.decode(Bool.self, forKey: .name)
        joinedGroupNotificationsOn = try container.decode(Bool.self, forKey: .name)

    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isOnboardingCompleted, forKey: .isOnboardingCompleted)
        try container.encode(name, forKey: .name)
        try container.encode(userID, forKey: .userID)
        try container.encode(country, forKey: .country)
        try container.encode(language, forKey: .language)
        try container.encode(description, forKey: .description)
        try container.encode(chatNotificationsOn, forKey: .chatNotificationsOn)
        try container.encode(joinedGroupNotificationsOn, forKey: .joinedGroupNotificationsOn)


    }
    
    @Published
    var isOnboardingCompleted = false
    
    @Published
    var name = ""
    
    @Published
    var userID = ""
    
    @Published
    var country = "United States"
    
    @Published
    var language = "English"
    
    @Published
    var description = "Lorem ipsum dolor sit amet, mea et animal probatus, id mutat corpora conclusionemque mei. No soluta recteque nec, commodo corrumpit sit ei. Ei per menandri vituperata. Vis ex meis persius volutpat.  Stet ullum viderer ne vel. Stet decore sed ut, ut quaestio voluptaria mea. Velit imperdiet gubergren pro te, an magna interpretaris qui. Homero reprehendunt pro ea. Summo fierent eu ius."
    
    @Published
    var chatNotificationsOn = true
    
    @Published
    var joinedGroupNotificationsOn = true
}







