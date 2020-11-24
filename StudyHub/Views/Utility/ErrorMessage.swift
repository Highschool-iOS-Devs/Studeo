//
//  ErrorMessage.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/7/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ErrorMessage: View {
    var errorObject:ErrorModel
    var displayError:Bool
    @State var translation = CGSize.zero
    var body: some View {
        Text("\(errorObject.errorMessage)")
            .animation(nil)
            .foregroundColor(.white)
            .frame(width: screenSize.width-15, height: 60)
            .background(Color(#colorLiteral(red: 0.8578633666, green: 0.1455268264, blue: 0.1380874515, alpha: 1)))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(displayError ? 1 : 0)
            .offset(x: 0, y: displayError ? 0 : -200)
            .offset(y:translation.height)
            .shadow(color: Color(#colorLiteral(red: 0.8578633666, green: 0.1455268264, blue: 0.1380874515, alpha: 1)).opacity(0.2), radius: 10, x: 0, y: 7)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0))
            .gesture(
                DragGesture()
                    .onEnded{value in
                        
                    }
                    .onChanged{value in
                        self.translation = value.translation
                    }
            )
    }
}
