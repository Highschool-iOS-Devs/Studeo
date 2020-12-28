//
//  LeaderboardView.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/23/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct LeaderboardView: View {
    @ObservedObject var leaderboardTab = LeaderBoardTabRouter()
    @State var people = [User]()
    @State var peopleDay = [User]()
    @State var peopleMonth = [User]()
    @State var leaders = [User]()
    @State var leadersDay = [User]()
    @State var leadersMonth = [User]()
    @State var user = [User]()
    @EnvironmentObject var userData: UserData
    @State var leadersHasLoaded = false
    @State var leadersDayHasLoaded = false
    @State var leadersMonthHasLoaded = false
    @State var showLoadingAnimation = true
    @State private var showShape = false
    var body: some View {
        ZStack {
            
            GeometryReader { geo in
                Ellipse()
                    .fill(Color.buttonBlue)
                    .frame(width: geo.size.width + 200, height: geo.size.height * 0.4)
                    .offset(x: -100, y: showShape ? (-(geo.size.height * 0.4) / 3.75) : -500)
            }
            
            VStack {
                Text("Leaderboard")
                    .font(.custom("Montserrat-SemiBold", size: 28))
                    .padding(.vertical, 22)
                dateSelectionView(currentDateTab: $leaderboardTab.currentDateTab)
                    .onAppear() {
                        self.loadData(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.people = userData
                            
                            
                        }
                        self.loadDataMonth(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.peopleMonth = userData
                            
                            
                        }
                        self.loadDataDay(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.peopleDay = userData
                            
                            
                        }
                        self.loadLeaderData(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.leaders = userData
                            self.leadersHasLoaded = true
                        }
                        self.loadLeaderDataMonth(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.leadersMonth = userData
                            self.leadersMonthHasLoaded = true
                        }
                        self.loadLeaderDataDay(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.leadersDay = userData
                            self.leadersDayHasLoaded = true
                        }
                        
                        self.loadUserData(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.user = userData
                            showLoadingAnimation = false
                            //self.leadersHasLoaded = true
                            
                            user[0].all = user[0].studyHours.reduce(0, +)
                           
                        }
                    }
                
                HStack {
                    ForEach(user){user in
                        SelfRankView(hours: user.all)
                            .padding(.top, 20)
                            .onAppear {
                                withAnimation {
                                    self.showShape = true
                                }
                            }
                    }
                }
                
                Spacer()
                if leaderboardTab.currentDateTab == .allTime {
                    
                    Spacer()
                    if self.leadersHasLoaded {
                        LeadersStack(leaders: leaders)
                    }
                    
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(people){user in
                                
                                LeaderboardRow(name: user.name, hours: user.studyHours)
                                    .onAppear() {
                                        print(user.name)
                                    }
                            }
                            
                            
                        }
                        .padding(.top, 22)
                        .padding(.bottom, 110)
                    }
                    
                }
//                } else if leaderboardTab.currentDateTab == .month {
//
//                    Spacer()
//                    if self.leadersMonthHasLoaded {
//                        LeadersStack(leaders: self.leadersMonth)
//                    }
//                    ScrollView {
//                        VStack(spacing: 30) {
//                            ForEach(peopleMonth){ user in
//                                LeaderboardRow(name: user.name, hours: user.month)
//                                    .onAppear() {
//                                        print(user.name)
//                                    }
//                            }
//
//                        }
//                        .padding(.top, 22)
//                        .padding(.bottom, 110)
//                    }
//                } else if leaderboardTab.currentDateTab == .today {
//
//                    Spacer()
//                    if self.leadersDayHasLoaded {
//                        LeadersStack(leaders: self.leadersDay)
//                    }
//                    ScrollView {
//                        VStack(spacing: 30) {
//                            ForEach(peopleDay){user in
//                                LeaderboardRow(name: user.name, hours: user.day)
//                                    .onAppear() {
//                                        print(user.name)
//                                    }
//                            }
//
//                        }
//                        .padding(.top, 22)
//                        .padding(.bottom, 110)
//                    }
//
//                }
//                Spacer(minLength: 120)
            }
            .font(.custom("Montserrat-SemiBold", size: 16))
            .foregroundColor(.white)
            
            if showLoadingAnimation {
                BlurView(style: .systemChromeMaterial)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    LottieUIView()
                        .animation(.easeInOut)
                    Text("Loading...")
                        .font(.custom("Montserrat-SemiBold", size: 25))
                        .offset(y: -40)
                }
                .frame(width: 300, height: 400)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                // .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 0)
                .animation(.easeInOut)
                
            }
        }
    }
    func loadData(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users")
        var userList:[User] = []
        //Get every single document under collection users
        let queryParameter = docRef.order(by: "studyHours", descending: true).limit(to: 100)
        queryParameter.getDocuments{ (querySnapshot, error) in
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
    func loadDataDay(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users")
        var userList:[User] = []
        //Get every single document under collection users
        let queryParameter = docRef.order(by: "day", descending: true).limit(to: 100)
        queryParameter.getDocuments{ (querySnapshot, error) in
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
    func loadDataMonth(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users")
        var userList:[User] = []
        //Get every single document under collection users
        let queryParameter = docRef.order(by: "month", descending: true).limit(to: 100)
        queryParameter.getDocuments{ (querySnapshot, error) in
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
    func loadLeaderData(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users")
        var userList:[User] = []
        let queryParameter = docRef.order(by: "studyHours", descending: true).limit(to: 3)
        //Get every single document under collection users
        queryParameter.getDocuments{ (querySnapshot, error) in
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
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            //  }
        }
        
        
    }
    func loadLeaderDataDay(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users")
        var userList:[User] = []
        let queryParameter = docRef.order(by: "day", descending: true).limit(to: 3)
        //Get every single document under collection users
        queryParameter.getDocuments{ (querySnapshot, error) in
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
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            //  }
        }
        
        
    }
    func loadLeaderDataMonth(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users")
        var userList:[User] = []
        let queryParameter = docRef.order(by: "month", descending: true).limit(to: 3)
        //Get every single document under collection users
        queryParameter.getDocuments{ (querySnapshot, error) in
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
            //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            
            //  }
        }
        
        
    }
    func loadUserData(performAction: @escaping ([User]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(self.userData.userID)
        var userList:[User] = []
        //Get every single document under collection users
        
        docRef.getDocument{ (document, error) in
            
            let result = Result {
                try document?.data(as: User.self)
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
            
            
            
            performAction(userList)
        }
        
        
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}

