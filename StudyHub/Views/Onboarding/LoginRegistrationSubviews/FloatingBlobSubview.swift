//
//  FloatingBlobSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct FloatingBlobSubview: View {
    @State var show = false
    @State var duration = 90.0
    var body: some View {
        ZStack{
            VectorImageRepresentable(image: #imageLiteral(resourceName: "blob_blue"), imageColor: Color("aqua dark"))
                .frame(width: 600, height: 600)
                .rotationEffect(.degrees(show ? 360 : 0))
                .offset(x: -120, y: 280)
                .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false))
                .onAppear{show=true}
                .opacity(0.85)

            VectorImageRepresentable(image: #imageLiteral(resourceName: "blob_blue"), imageColor: Color("aqua"))
                .frame(width: 600, height: 600)
                .rotationEffect(.degrees(show ? 360+90 : 90))
                .offset(x: 120, y: 320)
                .blendMode(.hardLight)
                .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false))
                .opacity(0.85)

        }
    }
}

struct FloatingBlobSubview_Previews: PreviewProvider {
    static var previews: some View {
        FloatingBlobSubview()
    }
}
