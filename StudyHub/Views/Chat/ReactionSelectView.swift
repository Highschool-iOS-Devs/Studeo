//
//  ReactionSelectView.swift
//  StudyHub
//
//  Created by Andreas on 1/8/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct ReactionSelectView: View {
    @State var reactions = ["love", "thumbsup", "celebrate", "laugh"]
 
    
    @Binding var message: MessageData
    @Binding var toggleReaction: Bool
    @State var group: Groups
    var body: some View {
        HStack {
           
        ForEach(reactions, id: \.self) { (reaction) in
            if reaction == "love" {
                Button(action: {
                    
                    message.reactions.append(reaction)
                    saveMessage(outgoingMessage: message)
                    toggleReaction = false
                }) {
                    Text("❤️")
                }
                
            } else
            if reaction == "thumbsup" {
                Button(action: {
                    
                    message.reactions.append(reaction)
                    saveMessage(outgoingMessage: message)
                    toggleReaction = false
                }) {
                    Text("👍")
                }
                
            } else
            if reaction == "laugh" {
             
                Button(action: {
                    
                    message.reactions.append(reaction)
                    saveMessage(outgoingMessage: message)
                    toggleReaction = false
                }) {
                    Text("🤣")
                }
            } else
            if reaction == "celebrate" {
                
                Button(action: {
                   
                    message.reactions.append(reaction)
                    saveMessage(outgoingMessage: message)
                    toggleReaction = false
                }) {
                    Text("🎉")
                }
            }
        }
        } 
    }
    func saveMessage(outgoingMessage:MessageData){
        let db = Firestore.firestore()
        let ref = db.collection("message/\(group.groupID)/messages/").document(message.id!)
        do{
            try ref.setData(from: outgoingMessage)
        }
        catch{
            print("Error saving data, \(error)")
        }
    }
}

