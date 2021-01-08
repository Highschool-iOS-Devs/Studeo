//
//  ChatCell.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI

//Subview for the chat bubble
struct ChatCellSelf: View {
    
    @State var name = ""
    
    @State var message: MessageData
    
    @State var toggleReaction = false
    
    @State var group: Groups
    var body: some View {
        
        ZStack(alignment: .leading) {
            VStack {
            HStack {
                Spacer()
                
                Text(self.message.messageText)
                    .foregroundColor(.white)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    .padding(12)
                    .background(Color("Primary"))
                    .clipShape(RoundedCorner(radius: 10, corners: .topLeft))
                    .clipShape(RoundedCorner(radius: 10, corners: .topRight))
                    .clipShape(RoundedCorner(radius: 10, corners: .bottomLeft))
                
                   
            } .padding(.trailing, 12)
            .onLongPressGesture {
                toggleReaction = true
               
            }
                HStack {
                    Spacer()
                Text(message.sentByName)
                    .font(.custom("Montserrat Light", size: 10))
                    
                } .padding(.trailing, 12)
                if !message.reactions.isEmpty {
                    HStack {
                        Spacer()
                    ForEach(message.reactions, id:\.self) { reaction in
                        if reaction == "love" {
                            Text(reaction == "love" ? "❤️" : "")
                                .font(.caption)
                        } else if reaction == "thumbsup" {
                            Text(reaction == "thumbsup" ? "👍" : "")
                                .font(.caption)
                        } else if reaction == "laugh"{
                            Text(reaction == "laugh" ? "🤣" : "")
                                .font(.caption)
                        } else if reaction == "celebrate" {
                       
                        Text(reaction == "celebrate" ? "🎉" : "")
                            .font(.caption)
                    }
                       
                    }
                        
                    } .padding(.trailing, 12)
                }
               
                if toggleReaction {
                    HStack {
                        Spacer()
                        ReactionSelectView(message: $message, toggleReaction: $toggleReaction, group: group)
                }
                }
            }
        } .transition(.opacity)
        .frame(minWidth: 100, minHeight: 50)
        .onTapGesture() {
            toggleReaction = false
        }
        
        
    }
    
}
//Subview for the chat bubble
struct ChatCell: View {
   @State var name = ""
    
    @State var message: MessageData
    
    @State var toggleReaction = false
    
    @State var group: Groups
    var body: some View {
        
        ZStack(alignment: .leading) {
            VStack {
            HStack {
                
                Text(self.message.messageText)
                    .foregroundColor(.white)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
                    .background(Color("OtherChatCell"))
                    .clipShape(RoundedCorner(radius: 10, corners: .topLeft))
                    .clipShape(RoundedCorner(radius: 10, corners: .topRight))
                    .clipShape(RoundedCorner(radius: 10, corners: .bottomRight))
                
                Spacer()
            } .padding(.horizontal, 12)
            .onLongPressGesture {
                toggleReaction = true
               
            }
                HStack {
                    
                Text(message.sentByName)
                    .font(.custom("Montserrat Light", size: 10))
                    Spacer()
                } .padding(.leading, 12)
                if !message.reactions.isEmpty {
                    HStack {
                       
                    ForEach(message.reactions, id:\.self) { reaction in
                        if reaction == "love" {
                            Text(reaction == "love" ? "❤️" : "")
                                .font(.caption)
                        } else if reaction == "thumbsup" {
                            Text(reaction == "thumbsup" ? "👍" : "")
                                .font(.caption)
                        } else if reaction == "laugh"{
                            Text(reaction == "laugh" ? "🤣" : "")
                                .font(.caption)
                        } else if reaction == "celebrate" {
                       
                        Text(reaction == "celebrate" ? "🎉" : "")
                            .font(.caption)
                    }
                       
                    }
                        Spacer()
                    } .padding(.leading, 12)
                }
                if toggleReaction {
                    HStack {
                    ReactionSelectView(message: $message, toggleReaction: $toggleReaction,  group: group)
                        
                        Spacer()
                    }
                }
        }
        
        } .transition(.opacity)
        .frame(minWidth: 100, minHeight: 50)
        .onTapGesture() {
            toggleReaction = false
        }
    }
}


extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
