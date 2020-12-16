//
//  ProfileRingView.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/27/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ProfileRingView: View {
    var image:Image
    var size:CGFloat
    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size, height: size)
            .clipShape(Circle())
            .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 2.5))
          
    }
}


struct ProfileRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileRingView(image:Image("demoprofile"), size: 56)
    }
}
