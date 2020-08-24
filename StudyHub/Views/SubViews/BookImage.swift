//
//  BookImage.swift
//  StudyHub
//
//  Created by Santiago Quihui on 23/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct BookImage: View {
    var bookName: String
    
    var body: some View {
        Image(bookName)
            .resizable()
            .scaledToFit()
            .frame(width: 160, height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            .padding(20)
    }
    
    init(_ book: String) {
        self.bookName = book
    }
}

struct BookImage_Previews: PreviewProvider {
    static var previews: some View {
        BookImage("bookexample")
    }
}
