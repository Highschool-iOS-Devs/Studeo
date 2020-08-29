//
//  ChatData.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI

struct ChatData: Identifiable {
    var id: String
    var name: String
    var message: String
    var isMe: Bool
    
    
    init(id: String, name: String, message: String, isMe: Bool) {
        self.id = id
        self.name = name
        self.message = message
        self.isMe = isMe
        
        
    }
}

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
