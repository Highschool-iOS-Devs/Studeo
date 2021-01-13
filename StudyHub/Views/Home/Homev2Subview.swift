//
//  Homev2Subview.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 1/12/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

extension Homev2 {
    
    func loadAllData() {
        // userData.hasDev = false
         recommendGroups.removeAll()
         if !user.isEmpty {
         if !user[0].studyHours.isEmpty {
         
         sum = user[0].studyHours.reduce(0, +)
             
             
         }
     }
         for group in recentPeople {
             for user in group.members {
                 if user != userData.userID {
                     users.append(user)
                     print(user)
                 }
             }
         }
         //users.removeDuplicates() //remove duplicates in user array
         
         ready = true
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
             withAnimation(.easeInOut(duration: 1.0)) {
               //  animation.toggle()
             }
         
         DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
             withAnimation(.easeInOut(duration: 1.0)) {
                // if userData.uses == 2 || userData.uses == 3 || userData.uses == 10 {
                     if !userData.hasDev {
         animate = true
                     }
        // }
             }
         }
         }
    }
    
    func getCorrectChatView() -> AnyView {
        if dmChat {
            return AnyView(ChatView(group: $recentPeople[self.i], navigationBarHidden: self.$navigationBarHidden, show: $dmChat)
                    .onDisappear {
                        dmChat = false
                        // prevent DM from not being able to be opened twice in a row
                        self.i = -1 // different placeholder? -1 wld crash
                    }
                    .navigationBarHidden(false))
            } else {
                return AnyView(ChatView(group: $devGroup, navigationBarHidden: self.$navigationBarHidden, show: $dmChat))
            }
    }
    
}

