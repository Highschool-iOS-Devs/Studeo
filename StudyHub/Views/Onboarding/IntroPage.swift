//
//  IntroPage.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct IntroPage: View {
    var titleText:String
    var bodyText:String
    var image:String
    
    @State var animate1 = false
    @State var animate2 = false
    @State var animate3 = false
    @State var animate4 = false
    @State var animate5 = false
    @State var animate6 = false
    
    @State var isOpenSourceView = false
    @State var devs = [Dev(id: UUID(), name: "Studeo", website: "", github: "https://github.com/Highschool-iOS-Devs/Studeo", insta: "", twitter: ""), Dev(id: UUID(), name: "Andreas Ink", website: "https://andreasink.web.app", github: "", insta: "", twitter: ""), Dev(id: UUID(), name: "Jevon Mao", website: "", github: "https://github.com/jevonmao", insta: "", twitter: ""), Dev(id: UUID(), name: "Dakshin Devanand", website: "", github: "https://github.com/DakshinD", insta: "@dakshin.devanand", twitter: ""), Dev(id: UUID(), name: "Santiago Quihui", website: "", github: "https://github.com/kiwis08", insta: "", twitter: "")]
    @ObservedObject var viewRouter: ViewRouter
    var body: some View {
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
                .onAppear() {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        animate1 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        animate2 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate3 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate4 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate5 = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        animate6 = true
                    }
                }
            VStack {
                HStack {
                    if animate1 {
                    Text(titleText)
                        .font(Font.custom("Montserrat-Bold", size: 25, relativeTo: .headline))
                        .foregroundColor(Color("Text"))
                        .padding(.vertical, 20)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 1.5))
                     
                }
                }
                if animate2 {
                Spacer()
                }
                if animate3 {
                Text(bodyText)
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Montserrat-Light", size: 15, relativeTo: .headline))
                  
                    .padding(.horizontal, 20)
                    .foregroundColor(Color("Text"))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5))
                }
                if animate4 {
                Spacer()
                }
                if animate5 {
                    if isOpenSourceView {
                        LazyVGrid(columns: [GridItem.init(.flexible( minimum: 80)), GridItem.init(.flexible(minimum: 80))]) {
                            
                            ForEach(devs) { dev in
                                VStack {
                                Text(dev.name)
                                    .multilineTextAlignment(.center)
                                    .font(Font.custom("Montserrat-Light", size: 15, relativeTo: .headline))
                                    .padding()
                                    .foregroundColor(Color("Text"))
                                HStack {
                                if !dev.website.isEmpty {
                                    Button(action: {
                                        if let url = URL(string: dev.website) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        Image("website")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                } else {
                                    Button(action: {
                                        if let url = URL(string: dev.github) {
                                            UIApplication.shared.open(url)
                                        }
                                    }) {
                                        Image("github")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                }
                                }
                            }
                        }
                    } else {
                Image(decorative: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width-40, height:screenSize.height/2.3)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5))
                    }
                    if animate6 {
                        
                        
                Spacer()
                    }
                }
               // Text("Skip for now")
                  //  .font(.custom("Montserrat-Regular", size: 17))
                   // .foregroundColor(Color.black.opacity(0.5))
                    //.padding(.bottom, 10)

           
            }
            
        }
    }
}


struct Dev: Identifiable, Hashable {
    var id: UUID
    var name: String
    var website: String
    var github: String
    var insta: String
    var twitter: String
}
