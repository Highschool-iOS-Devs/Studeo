//
//  FindingText.swift
//  StudyHub
//
//  Created by Andreas Ink on 12/11/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct FindingText: View {
    @State var dotdotdot = ""
    @Binding var text: String
    var body: some View {
        Text("\(text)\(dotdotdot)")
            .transition(.identity)
            .font(.custom("Montserrat-bold", size: 28))
            .onAppear() {
                let timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
                    withAnimation() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                dotdotdot = ""
                    
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    dotdotdot = "."
                        }
                
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    dotdotdot = ".."
                        }
                
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    dotdotdot = "..."
                        }
               
    }
}
}
    }
}


