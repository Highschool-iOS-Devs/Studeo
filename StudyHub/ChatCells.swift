//
//  ChatCells.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI

struct ChatV2Cell: View {
    
    @State var name = ""
    
    @State var message = ""
    
    var body: some View {
        
        
        ZStack(alignment: .leading) {
            
            HStack {
                Spacer()
                
                Text(message)
                    .foregroundColor(.white)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    .padding(12)
                    .background(Color("teal"))
                    .cornerRadius(10)
                
                
            } .padding(.trailing, 12)
        }
        
        
        
    }
}
struct ChatV2Cell2: View {
    @State var name = ""
    @State var message = ""
    var body: some View {
        ZStack(alignment: .trailing) {
            
            HStack() {
                
                Text(message)
                    .foregroundColor(.white)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
                    .background(Color(.gray))
                    .cornerRadius(10)
                Spacer()
            } .padding(.leading, 12)
        }
        
        
        
    }
}
