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
    @EnvironmentObject var viewRouter: ViewRouter
    @State var animate1 = false
    @State var animate2 = false
    @State var animate3 = false
    @State var animate4 = false
    @State var animate5 = false
    @State var animate6 = false
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
                        .font(.custom("Montserrat-Bold", size: 25))
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
                    .font(.custom("Montserrat-light", size: 15))
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color("Text"))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5))
                }
                if animate4 {
                Spacer()
                }
                if animate5 {
                Image(decorative: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width-40, height:screenSize.height/2.3)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 1.5))
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

struct IntroPage_Previews: PreviewProvider {
    static var previews: some View {
        IntroPage(titleText: "Customization", bodyText: "Select your classes and learning topics and we'll recommend groups where you can find help.", image: "studying_drawing")
    }
}
