//
//  ChatCell.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI

struct ChatCellSelf: View {
    
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
                    .background(Color(.systemBlue))
                    .cornerRadius(10)
                
                
            } .padding(.trailing, 12)
        }
        
        
        
    }
}
struct ChatCell: View {
   @State var name = ""
    
    @State var message = ""
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            HStack {
                
                Text(message)
                    .foregroundColor(.white)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                
                Spacer()
            } .padding(.horizontal, 12)
        }
        
        
        
    }
}

struct ChatCells_Preview: PreviewProvider {
    static var previews: some View {
        //ChatCellsSelf(message: "Hello how are you doing?")
        ChatCell(message: "Hi!")
    }
}
