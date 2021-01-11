//
//  TitleSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 11/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TitleSubview: View {
    var titleText:String
    var image:String
    var body: some View {
        VStack {
            Text(titleText)
                .font(Font.custom("Montserrat-Bold", size: 24, relativeTo: .headline))
                .padding(.bottom, 40)
                .foregroundColor(Color("Text"))
            Image(decorative: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                //.frame(height: 220)
        }
    }
        
        
}

