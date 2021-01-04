//
//  QuizData.swift
//  Christmas
//
//  Created by Andreas on 12/19/20.
//

import SwiftUI

struct Quiz: Identifiable {
    var id: String
    var questions: [Question]
    
}

struct Question: Identifiable, Codable, Hashable{
    var id: String
    var question: String
    var answers: [String]
    var answer: String
    var selected: String
}
struct Question2: Identifiable{
    var id: String
    var question: String
    var answers: [String]
    var answer: String
    var selected: String
}
