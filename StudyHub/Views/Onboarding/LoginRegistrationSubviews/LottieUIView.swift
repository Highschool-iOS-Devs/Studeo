//
//  LottieUIView.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/17/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct LottieUIView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    LottieView()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}

struct LottieUIView_Previews: PreviewProvider {
    static var previews: some View {
        LottieUIView()
    }
}
