//
//  ChatCell.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI

//Subview for the chat bubble
struct ChatCellSelf: View {
    
    @State var name = ""
    
    @State var message = ""
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            
            HStack {
                Spacer()
                
                Text(self.message)
                    .foregroundColor(.white)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    
                    .padding(12)
                    .background(Color("Primary"))
                    .clipShape(RoundedCorner(radius: 10, corners: .topLeft))
                    .clipShape(RoundedCorner(radius: 10, corners: .topRight))
                    .clipShape(RoundedCorner(radius: 10, corners: .bottomLeft))
                
                
            } .padding(.trailing, 12)
        }
        
        
        
    }
}
//Subview for the chat bubble
struct ChatCell: View {
   @State var name = ""
    
    @State var message = ""
    
    var body: some View {
        
        ZStack(alignment: .leading) {
            VStack {
            HStack {
                
                Text(self.message)
                    .foregroundColor(.white)
                    .lineLimit(.none)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(12)
                    .background(Color("Secondary"))
                    .clipShape(RoundedCorner(radius: 10, corners: .topLeft))
                    .clipShape(RoundedCorner(radius: 10, corners: .topRight))
                    .clipShape(RoundedCorner(radius: 10, corners: .bottomRight))
                
                Spacer()
            } .padding(.horizontal, 12)
                
        }
        
        }
        
    }
}

struct ChatCells_Preview: PreviewProvider {
    static var previews: some View {
        //ChatCellsSelf(message: "Hello how are you doing?")
        ChatCell(message: "Hi!")
    }
}
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
