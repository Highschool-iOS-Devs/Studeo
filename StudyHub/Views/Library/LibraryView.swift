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
        VStack {
            LibraryHeader()
            TextField("Search Books", text: $search)
                .textFieldStyle(SearchTextField())
            ScrollView(showsIndicators: false) {
                LibraryCollectionView(collectionTitle: "Popular")
                LibraryCollectionView(collectionTitle: "For You")
                LibraryCollectionView(collectionTitle: "Popular")
                LibraryCollectionView(collectionTitle: "For You")
            }
        }
    }
}

struct LibraryCollectionView: View {
    
    var collectionTitle: String
    
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
                        BookImage(self.books[book])
                    }
                }
            }
        }.padding([.bottom, .horizontal], 30)
    }
}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}
