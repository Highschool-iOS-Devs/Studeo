//
//  AllGroupTextRow.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/15/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct AllGroupTextRow: View {
    var body: some View {
        HStack{
            VStack(alignment:.leading){
                Text("All Study Groups").font(.custom("Montserrat Bold", size: 24)).foregroundColor(Color("Primary"))
            }
            Spacer()
          //  Text("View all").font(.custom("Montserrat Regular", size: 15)).foregroundColor(Color("Primary"))
        }
        .padding(.bottom, 40)
        .padding(.horizontal, 20)
            
        
    }
}

struct AllGroupTextRow_Previews: PreviewProvider {
    static var previews: some View {
        AllGroupTextRow()
    }
}
