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
    var geometry: GeometryProxy
    
    var body: some View {
        Image(bookName)
            .resizable()
            .scaledToFit()
            .frame(width: geometry.size.width * 0.35)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 10)
            .padding(20)
    }
    
    init(_ book: String, geometry: GeometryProxy) {
        self.bookName = book
        self.geometry = geometry
    }
}

struct BookImage_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geo in
            BookImage("bookexample", geometry: geo)
        }
    }
}
