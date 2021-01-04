//
//  BottomCardSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/27/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct BottomCardSubview: View {
    var displayView:AnyView
    @State var bottomState = CGSize.zero
    @Binding var showFull:Bool
    @Binding var showCard:Bool
    var body: some View {
        
        ZStack{
            Color("Background")
                .edgesIgnoringSafeArea(.all)
                
            displayView
                .padding(.top,20)

            VStack{
                Capsule()
                    .fill(Color("Text").opacity(0.3))
                    .frame(width: 50, height: 5)
                    .padding(.top, 10)
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.all)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .offset(y:showCard ? 360 : 1000)
        .offset(y: showFull ? bottomState.height-300 : bottomState.height)
        .shadow(radius: 30)
        .gesture(
            DragGesture()
                .onChanged { value in
                    print(bottomState.height)
                    if self.showFull{
                        if value.translation.height > 0{
                            self.bottomState = value.translation
                        }
                    }
                    else{
                        self.bottomState = value.translation
                    }

                    if self.bottomState.height < -300 {
                        self.bottomState.height = -300
                    }
              
            }
            .onEnded { value in
                if value.translation.height < -300 {
                    self.bottomState.height = -300
                }
                if self.bottomState.height > 50 {
                    self.showCard = false
                    showFull = false
                    self.bottomState = .zero
                }
                else{
                    self.bottomState = .zero

                }
            }
        )

        .animation(.timingCurve(0.2, 0.8, 0.2, 1, duration:0.8))
  
    }
}

