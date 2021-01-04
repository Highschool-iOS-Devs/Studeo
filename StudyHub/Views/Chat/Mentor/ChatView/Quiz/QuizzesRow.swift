//
//  QuizzesRow.swift
//  StudyHub
//
//  Created by Andreas on 1/4/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct QuizzesRow: View {
    @State var quiz =  Quiz(id: UUID().uuidString, name: "", tags: [String](), questions: [Question]())
    var body: some View {
        HStack {
            Text(quiz.name)
                .font(.custom("Montserrat Bold", size: 18))
            Button(action: {
                
            }) {
                Text("Start")
            } .buttonStyle(BlueStyle())
        } .padding()
    }
}

struct QuizzesRow_Previews: PreviewProvider {
    static var previews: some View {
        QuizzesRow()
    }
}
