//
//  IntroView.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 8/24/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                VStack() {
                    HStack {
                        Text("E - Study")
                            .font(.custom("Montserrat-SemiBold", size: 32))
                            .bold()
                            .foregroundColor(.white)
                            .offset(y: -15)
                        Spacer()
                    }
                    .padding(.top, geometry.size.height/7)
                    .padding(.leading, 60)
                    Image("study")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width-40, height: geometry.size.height/2.3)
                        .offset(y: -25)
                    Text("A better learning\nfuture starts here")
                        .font(.custom("Montserrat-SemiBold", size: 26))
                        .bold()
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .offset(y: -40)
                        .padding(.top, 10)
                    Spacer()
                    Button(action: { }) {
                        Text("Get Started")
                            .font(.custom("Montserrat-SemiBold", size: 14))
                    }
                    .buttonStyle(BlueStyle())
                    .padding(.bottom, geometry.size.height/15)
                    .padding(.horizontal, 35)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)

            }
        }
        
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
