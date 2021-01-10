//
//  ChatHeader.swift
//  StudyHub
//
//  Created by Andreas on 1/8/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct ChatHeader: View {
    @State var group: Groups
    @Binding var isDMs: Bool
    var body: some View {
        if isDMs {
        HStack {
            Text(group.groupName)
                .font(.custom("Montserrat Bold", size: 14))
        Spacer()
        } .padding()
    }
}
}

