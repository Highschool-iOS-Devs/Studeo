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
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
            Image(imgName)
                
                .renderingMode(.original)
           
                .resizable()
               // .frame(width: 350, height: 350)
                
                .scaledToFill()
                    Spacer()
                }
                Spacer()
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                        .padding(.leading, 30)
                    Button(action: {
                        self.userData.tappedCTA = true
                        if self.cta == "Find Study Partners" {
                            self.tabRouter.currentView = .chatList
                            
                            
                        } else if self.cta == "Add Group" {
                            self.tabRouter.currentView = .chatList
                            
                        } else if self.cta == "Find a Mentor" {
                            self.tabRouter.currentView = .mentor
                        } else {
                            self.tabRouter.currentView = .leaderboard
                            
                        }
                        
                    }) {
                        
                        Text(cta)
                            .font(.headline)
                            .multilineTextAlignment(.trailing)
                        
                        
                        
                    } .buttonStyle(BlueStyle())
                       
                        
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
