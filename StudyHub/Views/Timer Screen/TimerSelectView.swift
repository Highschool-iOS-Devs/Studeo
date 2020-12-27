//
//  TimerSelectView.swift
//  StudyHub
//
//  Created by Andreas on 12/26/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct TimerSelectView: View {
    @State var categories = ["Math", "Science", "Social Studies", "Foreign Language", "English", "Computer Science", "Other"]
    @Binding var category: String
    @StateObject private var timer = TimerManager()
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
        ForEach(categories, id: \.self) { text in
        
            Button(action: {
                category = text
                timer.category = text
            }) {
                Text(text)
                    .multilineTextAlignment(.leading)
                    .font(.custom("Montserrat-Semibold", size: 18))
                    
                    .foregroundColor(.white)
            } .padding()
                .background(RoundedRectangle(cornerRadius: 25.0).foregroundColor(category == text ? Color("Secondary") :  Color("Primary")))
            
            
        }
        }
        } .padding()
}
}
