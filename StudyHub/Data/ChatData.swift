//
//  ChatData.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI



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
    var groupName:String
    var groupID:String
    var createdBy:String
    var members:[String]
    var interests:[String]
}

struct MessageData:Codable, Hashable{ 
    var messageText:String
    var sentBy:String
    var sentTime:Date
    var sentBySelf:Bool?
 
}
