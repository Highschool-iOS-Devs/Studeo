//
//  GroupsView.swift
//  StudyHub
//
//  Created by Andreas Ink on 10/21/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct GroupsView: View {
    @State var imgName = ""
    @State var cta = ""
    @State var name = ""
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var tabRouter:ViewRouter
    let screenSize = UIScreen.main.bounds
    var body: some View {
        ZStack {
            
                
                   
                    Image(imgName)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: screenSize.width/1.5, maxWidth: screenSize.width, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: screenSize.width/1.5, maxHeight: screenSize.height/7, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
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
                }
                        
                }
            
           
        }
    }
}

struct GroupsView_Previews: PreviewProvider {
    static var previews: some View {
        GroupsView()
    }
}
