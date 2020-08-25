//
//  LibraryView.swift
//  StudyHub
//
//  Created by Santiago Quihui on 23/08/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct LibraryView: View {
    @State private var search = ""
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                LibraryHeader()
                TextField("Search Books", text: self.$search)
                    .textFieldStyle(SearchTextField())
                ScrollView(showsIndicators: false) {
                    LibraryCollectionView(collectionTitle: "Popular", geo)
                    LibraryCollectionView(collectionTitle: "For You", geo)
                    LibraryCollectionView(collectionTitle: "Popular", geo)
                    LibraryCollectionView(collectionTitle: "For You", geo)
                }
            }
        }
    }
}

struct LibraryCollectionView: View {
    
    var collectionTitle: String
    
    var geometry: GeometryProxy
    
    let books: [String] = Array(repeating: "bookexample", count: 5)
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(collectionTitle)
                    .font(Font.custom("Montserrat-SemiBold", size: 18))
                Spacer()
            }
            .padding(.horizontal, 15)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(0 ..< books.count, id:\.self) { book in
                        BookImage(self.books[book], geometry: self.geometry)
                    }
                }
            }
        }.padding([.bottom, .horizontal], 30)
    }
    
    init(collectionTitle: String, _ geo: GeometryProxy) {
        self.collectionTitle = collectionTitle
        self.geometry = geo
    }
}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
