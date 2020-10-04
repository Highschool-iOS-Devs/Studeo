//
//  ChatData.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI


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
