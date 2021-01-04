//
//  QuizAddRow.swift
//  StudyHub
//
//  Created by Andreas on 1/3/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct QuizAddRow: View {
    @State var question = ""
    @State var answer1 = ""
    @State var answer2 = ""
    @State var answer3 = ""
    var body: some View {
        VStack {
           
                QuizInputFieldView(text: $question, isQuestion: true)
                
            
            Spacer()
            
                QuizInputFieldView(text: $answer1)
                QuizInputFieldView( text: $answer2)
                QuizInputFieldView( text: $answer3)
            
        } .padding()
    }
}

struct QuizAddRow_Previews: PreviewProvider {
    static var previews: some View {
        QuizAddRow()
    }
}
