//
//  ChatData.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI
import FirebaseFirestoreSwift


struct ChattedWith: Identifiable {
    var id: String
    var name: String
    var count: Int
    var chatRoom: String
    
    init(id: String, name: String, count: Int, chatRoom: String) {
        self.id = id
        self.name = name
        self.count = count
        self.chatRoom = chatRoom
        
        
    }
}

 
struct Groups: Identifiable, Codable, Hashable{
    var id: String
    var groupID:String
    var groupName:String
    var members:[String]
    var membersCount:Int
    var interests:[UserInterestTypes?]
    var recentMessage:String?
    var recentMessageTime:Date?
    var userInVC: [String]?
}


struct MessageData: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    var messageText:String
    var sentBy:String
    var sentTime:Date
    var sentBySelf:Bool?
 
}
