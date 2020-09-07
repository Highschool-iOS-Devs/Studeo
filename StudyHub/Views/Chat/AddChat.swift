//
//  AddChat.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.


import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseCore

struct AddChat: View {
    @EnvironmentObject var userData:UserData
    @EnvironmentObject var viewRouter:ViewRouter
    @ObservedObject var chatDataInfo = ChatDataInfo.sharedChatData
    @State var presentCreateView = false
    @State var groupList = [Groups]()
    var body: some View {
        VStack{
            CustomHeader()
            SearchBar()
            Text("Popular")
                .font(.custom("Montserrat-semibold", size: 18))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    AddNewGroupView()
                        .onTapGesture {
                            self.presentCreateView = true
                            //Tempoarily manual adding a new group type for testing the chat
                            let db = Firestore.firestore()
                            let docRef = db.collection("groups")
                            let newGroup = Groups(groupName: "SAT", groupID: UUID().uuidString, createdBy: self.userData.userID, members: [self.userData.userID], interests: ["SAT","Exam"])
                            do{
                                try docRef.document(newGroup.groupID).setData(from: newGroup)
                                self.loadGroups()
                                
                            }
                            catch{
                                print("Error writing to database, \(error)")
                            }
                            
                    }
                    .sheet(isPresented: $presentCreateView){
                        Text("Some implementation here to allow user to put in group information.")
                    }
                    ForEach(groupList, id:\.self){group in
                        GroupListView(titleText: group.groupName)
                            .onTapGesture{
                                self.chatDataInfo.chatID = group.groupID
                                self.viewRouter.updateCurrentView(view: .chats)
                                
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            Spacer()
            
        }
        .onAppear{
            FirebaseApp.configure()
            self.loadGroups()
        }
    }
    
    func loadGroups(){
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        docRef.getDocuments(){querySnapshot, error in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let result = Result{
                        try document.data(as: Groups.self)
                    }
                    switch result {
                    case .success(let groups):
                        if let groups = groups {
                            self.groupList.append(groups)
                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding groups: \(error)")
                    }
                }
            }

        }
    }
}
        struct AddChat_Previews: PreviewProvider {
            static var previews: some View {
                AddChat()
            }
        }
        struct CustomHeader: View {
            @EnvironmentObject var userData: UserData
            var body: some View {
                HStack {
                    
                    Text("Study Groups")
                        .frame(minWidth: 150, alignment: .leading)
                        .font(.custom("Montserrat-Semibold", size: 24))
                        .foregroundColor(Color(.black))
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        
                        Image("demoprofile")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 50, height: 50)
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(LinearGradient(gradient: Gradient(colors: [.gradientLight, .gradientDark]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 5))
                    } .padding(.trailing, 22)
                    
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        ZStack {
                            Color(.white)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                            Image("clock")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 25, height: 25)
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                            
                        }
                    }
                    
                } .padding(.horizontal, 12)
            }
        }
        //    @EnvironmentObject var userData: UserData
        //    @State var hasAppeared = false
        //    @State var categories = [Categories]()
        //    @State var people = [BasicUser]()
        //    @State var hasSearched = false
        //    @State var matchedPerson = BasicUser(id: "", name: "", count: 0)
        //    @State var personCount = -1
        //    @State var chatRoom = ""
        //    @State var userIDs = ""
        //    @State var hasInteractedBefore = false
        //    @State var hasFound = false
        //    var body: some View {
        //        ZStack {
        //            Color(.white)
        //                .onAppear() {
        //
        //
        //                    self.categories = [Categories(id: "0", name: "College Apps", count: 0), Categories(id: "1", name: "SAT", count: 1),Categories(id: "2", name: "AP Gov", count: 2), Categories(id: "3", name: "APUSH", count: 3), Categories(id: "4", name: "AP World", count: 4),Categories(id: "5", name: "AP Macro", count: 5)]
        //                    self.hasAppeared = true
        //            }
        //
        //            if self.hasAppeared {
        //                ScrollView {
        //                    ForEach(categories, id: \.id) { category in
        //                        Group {
        //
        //                            AddChatCell(name: category.name)
        //                                .onTapGesture {
        //
        //
        //
        //                            }
        //
        //
        //
        //
        //                            Divider()
        //
        //                        }
        //                    }
        //                    Button(action: {
        //                        do{
        //                            try Auth.auth().signOut()
        //
        //                        }
        //                        catch{
        //                            print("\(error)")
        //                        }
        //                    }){
        //                        Text("Sign out")
        //                    }
        //                } .padding(.top, 22)
        //            }
        //            if hasSearched {
        //                ZStack {
        //
        //                    Color(.white)
        //                    ChatV2(matchedPerson: self.matchedPerson.name, chatRoom: self.chatRoom, matchedPersonID: self.matchedPerson.id, addChat: true)
        //
        //                }
        //            }
        //        }
        //    }
        //
        //}
        //
        
        struct SearchBar: View {
            @State var search = ""
            var body: some View {
                ZStack {
                    HStack {
                        Spacer()
                        Divider()
                            .frame(height: 25)
                        Image("dropdown")
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 15, height: 15)
                            .aspectRatio(contentMode: .fit)
                            
                            .onAppear() {
                                //self.userData.interactedPeople.removeAll()
                        }
                    } .padding(.horizontal, 44)
                    TextField("Search", text: $search)
                        .font(Font.custom("Montserrat-Regular", size: 15.0))
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10.0)
                    
                } .padding(.horizontal, 22)
                    .padding(.vertical, 22)
            }
        }
        
        struct GroupListView: View, Hashable {
            var titleText:String
            var body: some View {
                VStack {
                    HStack {
                        Text(titleText)
                            .font(.custom("Montserrat-semibold", size: 25))
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.top, 15)
                    Spacer()
                }
                .frame(width: 220, height: 220)
                .background(Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
        }
        struct AddNewGroupView: View {
            var body: some View {
                VStack {
                    
                    Text("Add new")
                        .font(.custom("Montserrat-semibold", size: 25))
                        .foregroundColor(.white)
                    Text("No study groups has been created yet.")
                        .font(.custom("Montserrat", size: 12))
                        .lineLimit(.none)
                        .foregroundColor(.white)
                        
                        .padding(.horizontal, 15)
                        .padding(.top, 15)
                    
                    Image(systemName: "plus.circle")
                        .font(.system(size: 100))
                        .foregroundColor(Color.white.opacity(0.5))
                        .padding()
                    
                }
                .frame(width: 220, height: 220)
                .background(Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            }
    }

