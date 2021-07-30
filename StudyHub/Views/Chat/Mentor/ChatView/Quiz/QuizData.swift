//
//  QuizData.swift
//  Christmas
//
//  Created by Andreas on 12/19/20.
//

import SwiftUI

struct Quiz: Identifiable, Hashable, Codable {
    var id: String
    var name: String
    var tags: [String]
    var questions: [Question]
    var groupID: String
}

struct Question: Identifiable, Codable, Hashable {
    var id: String
    var question: String
    var answers: [String]
    var answer: String
    var selected: String
    var quizID: String
}
struct Question2: Identifiable {
    var id: String
    var question: String
    var answers: [String]
    var answer: String
    var selected: String
}
