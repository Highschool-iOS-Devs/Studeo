//
//  Home.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var userData: UserData
    var body: some View {
        VStack {
            Header()
            Spacer()
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
