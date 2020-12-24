//
//ChatList.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
//
import SwiftUI
import Firebase
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

//Currently recent view will display all users because chatting is not set up yet
struct RecentsView: View {
    //List for UI displaying the list of people
    @State var recentPeople = [User]()
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: ViewRouter
    @State var group = Groups(id: "", groupID: "", groupName: "", members: [""], interests: [nil])
    //For passing information into chat view. When user taps on a people in the scroll list, it should take user to the chat view.
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
            Spacer()
            VStack{
                Text("Recent Chats")
                    .font(.custom("Montserrat-Bold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.vertical, 30)
                
                ForEach(recentPeople){user in
                    RecentPersonView(name: user.name, group: group)
                        .onTapGesture {
                            
                    }
                }
                
                Spacer()
            }
            .frame(height: 600)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
                .offset(x: 0, y: 50)
                .onAppear{
                    self.loadData(){userData in
                        //Get completion handler data results from loadData function and set it as the recentPeople local variable
                        self.recentPeople = userData
                    }
            }
            }
        }
    }
    
    func loadData(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users")
        var userList:[User] = []
        //Get every single document under collection users
        docRef.getDocuments{ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: User.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            userList.append(user)
                 
                        } else {
                            
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
                
              
            }
              performAction(userList)
        }
        
        
    }
}
struct ChatList_Previews: PreviewProvider {
    static var previews: some View {
        RecentsView()
    }
}


struct RecentPersonView: View {
    var name:String
    @State var group = Groups(id: "", groupID: "", groupName: "", members: [""], interests: [nil])
    @State var tapped: Bool = false
    @State var image = UIImage()
    @State var chat = false
    @EnvironmentObject var userData: UserData
    var body: some View {
        HStack{
            Image(uiImage: image)
                .resizable()
                .clipShape(Circle())
                .aspectRatio(contentMode: .fill)
                .frame(width: 55, height: 55)
            
            Text(group.groupName)
                .font(.custom("Montserrat-SemiBold", size: 18))
                .padding(.leading, 25)
                .foregroundColor(.black)
            Spacer()
        } .onTapGesture {
            tapped.toggle()
        }
        .sheet(isPresented: self.$tapped){
            ChatView(group: group, chat: $chat)
                .environmentObject(userData)
        }
        .padding(.horizontal, 15)
    }
}
