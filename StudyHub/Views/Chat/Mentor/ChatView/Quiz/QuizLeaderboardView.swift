

import SwiftUI
import Firebase
struct QuizLeaderboardView: View {
    @Binding var users: [User]
    @ObservedObject var quizRouter: QuizRouter
    @State var isAndreas = true
    @State var group: Groups
    @State var quiz: Quiz
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.custom("Montserrat SemiBold", size: 10))
                .foregroundColor(.white)
                .padding()
        List {
            
            ForEach(users.indices) { i in
                QuizLeaderboardRow(user: users[i], i: i, group: group, quiz: quiz)
        }
    }
            Button(action: {
                quizRouter.currentView = .question
            }) {
                Text("Next")
            } .buttonStyle(BlueStyle())
    }
}
}

