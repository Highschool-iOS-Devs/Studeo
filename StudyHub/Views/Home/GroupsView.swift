//
//  GroupsView.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/21/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct GroupsView: View {
    var imgName:String
    var cta:String
    var name:String
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var tabRouter:ViewRouter
    let screenSize = UIScreen.main.bounds
    var body: some View {
        ZStack {
        
       
        Image(imgName)
            .resizable()
            .scaledToFit()
            .frame(width: screenSize.width/1.5, height: screenSize.width/1.5)
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            VStack {
            HStack {
            Text(name)
                .font(.headline)
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
                       
                        
                    }) {
                        Text(cta)
                            .font(.headline)
                            .multilineTextAlignment(.trailing)
                        
                        
                        
                    } .buttonStyle(BlueStyle())
                    .shadow(radius: 5)
                    .offset(y: -30)
                }
                        
                }
            
           
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView(imgName: "2868759", cta: "Chat", name: "Name")
    }
}
