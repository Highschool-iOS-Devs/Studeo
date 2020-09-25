//
//  Leaderboard.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct Leaderboard: View {
    @State var users = [User]()
    @State var all: Bool = false
    @State var month: Bool = false
    @State var day: Bool = false
    var body: some View {
        VStack {
        HStack(spacing: 30) {
            
            Color(.white)
            }
        
        ScrollView {
            VStack(spacing: 30) {
                ForEach(users){user in
                    
                    LeaderboardRow(name: user.name, hours: user.studyHours)
                        .onAppear() {
                            print(user.name)
                    }
                }
            }
        }
            
            }
    }
}

struct Leaderboard_Previews: PreviewProvider {
    static var previews: some View {
        Leaderboard()
    }
}
