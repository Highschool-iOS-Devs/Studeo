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

final class UserData: ObservableObject {
    
    public static let shared = UserData()
    
    @Published(key: "firstRun")
    var firstRun: Bool = true
    
    @Published(key: "isOnboardingCompleted")
    var isOnboardingCompleted: Bool = false
    
    @Published(key: "isSetupCompleted")
    var isSetupCompleted: Bool = false
    
    @Published(key: "name")
    var name: String = "nil"
    
    @Published(key: "userID")
    var userID: String = "nil"
    
    @Published(key: "hasInteractedWith")
    var interactedPeople: [String] = [""]
    
    @Published(key: "hasInteractedWith")
    var interactedChatRoom: [String] = [""]
    
    @Published(key: "chats")
    var chats: [String] = [""]
    
    @Published(key: "isLoggedIn")
    var isLoggedIn: Bool = false
    
    // Change notification settings when these 2 variables are changed
    @Published(key: "chatNotificationsOn")
    var chatNotificationsOn: Bool = true
    
    @Published(key: "joinedGroupNotificationsOn")
    var joinedGroupNotificationsOn: Bool = true
    
    @Published
    var onboard: Int = 0
    
    @Published
    var fcmToken: String = ""
    
    @Published
    var tabBar: Int = 0
    
    @Published
    var notifications: Bool = false
    
    @Published
    var country: String = "United States"
    
    @Published
    var language: String = "English"
    
    @Published
    var tappedCTA: Bool = false
    
    @Published
    var profilePictureURL: URL?
    
    @Published
    var description: String = "Lorem ipsum dolor sit amet, mea et animal probatus, id mutat corpora conclusionemque mei. No soluta recteque nec, commodo corrumpit sit ei. Ei per menandri vituperata. Vis ex meis persius volutpat.  Stet ullum viderer ne vel. Stet decore sed ut, ut quaestio voluptaria mea. Velit imperdiet gubergren pro te, an magna interpretaris qui. Homero reprehendunt pro ea. Summo fierent eu ius."
}

import Foundation
import CryptoKit

extension UserDefaults {
    
    public struct Key {
        public static let lastFetchDate = "lastFetchDate"
    }
    
    @objc dynamic public var lastFetchDate: Date? {
        return object(forKey: Key.lastFetchDate) as? Date
    }
}

import Foundation
import Combine

extension Published {
    
    init(wrappedValue defaultValue: Value, key: String) {
        let value = UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue
        self.init(initialValue: value)
        projectedValue.receive(subscriber: Subscribers.Sink(receiveCompletion: { (_) in
            ()
        }, receiveValue: { (value) in
            UserDefaults.standard.set(value, forKey: key)
        }))
    }
    
}
