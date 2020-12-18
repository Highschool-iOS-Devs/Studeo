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
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text(titleText)
                        .font(.custom("Montserrat-Bold", size: 25))
                        
                        .padding(.vertical, 20)
                    
                }
                Text(bodyText)
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-light", size: 15))
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: screenSize.width-40, height:screenSize.height/2.3)
                
                Spacer()
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
