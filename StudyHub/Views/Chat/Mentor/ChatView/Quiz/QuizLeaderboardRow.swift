
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
struct QuizLeaderboardRow: View {
    @State var user: User
    @State var i = 0
    @State var points = 0
    @State var group: Groups
    @State var quiz: Quiz
    var body: some View {
        HStack {
            Text("\(i + 1)")
                .font(.custom("Montserrat SemiBold", size: 10))
                .padding(.horizontal)
            ProfilePic(name: user.name, id: user.id.uuidString)
            Text(user.name)
                .font(.custom("Montserrat SemiBold", size: 10))
            Spacer()
            Text("\(points)")
                .font(.custom("Montserrat SemiBold", size: 10))
        } .padding()
        .onAppear() {
            loadUserData()
        }
    }
    func loadUserData() {
       
        let db = Firestore.firestore()
        let docRef = db.collection("quizzes").document("\(group.id)/\(quiz.id)/\(user.id.uuidString)")
        docRef.getDocument(source: .default) { (document, error) in
                    if let document = document {
                        points = document.get("points") as? Int ?? 0
                        
                    } else {
                        print("Document does not exist in cache")
                    }
                }
    }
}

