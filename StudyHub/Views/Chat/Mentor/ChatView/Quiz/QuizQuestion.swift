//
//  QuizQuestion.swift
//  Christmas
//
//  Created by Andreas Ink on 12/19/20.
//

import SwiftUI

struct QuizQuestion: View {
   @Binding var question: Question
    @Binding var i: Int
    @State var text = "Term"
    @State var image = UIImage()
    var body: some View {
     
            
        Text(question.question)
           .font(.custom("Montserrat Bold", size: 18)).foregroundColor(Color("Primary"))
            .multilineTextAlignment(.center)
            
            
    }
}


