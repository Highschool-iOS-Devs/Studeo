//
//  CTA.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct CTA: View {
    @State var imgName = ""
    @State var cta = ""
    var tabRouter:ViewRouter = .shared
    @State var currentView: ViewRouter.Views = .home
     @EnvironmentObject var userData: UserData
    var body: some View {
        ZStack {
            
            Image(imgName)
                .renderingMode(.original)
                .resizable()
                .frame(width: 350, height: 350)
                .padding(.horizontal, 12)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        
                        if self.cta == "Add Friends" {
                            self.tabRouter.currentView = .chatList
                            self.userData.tappedCTA = true
                            
                        } else if self.cta == "Add Group" {
                            self.tabRouter.currentView = .groups
                             self.userData.tappedCTA = true
                        } else {
                            self.tabRouter.currentView = .leaderboard
                             self.userData.tappedCTA = true
                        }
                        
                    }) {
                        Text(cta)
                        
                        
                        
                        
                    } .buttonStyle(BlueStyle())
                        .frame(width: 125)
                }
            } .padding(.all, 22)
        }
    }
}

struct CTA_Previews: PreviewProvider {
    static var previews: some View {
        CTA()
    }
}
