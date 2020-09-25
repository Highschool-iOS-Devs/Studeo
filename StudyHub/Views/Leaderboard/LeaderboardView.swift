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
    @State var showLoadingAnimation = true
    var body: some View {
        ZStack {
            ScrollView {
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
                            
                        }
                        self.loadLeaderDataMonth(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.leadersMonth = userData
                           
                        }
                        self.loadLeaderDataDay(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.leadersDay = userData
                            self.leadersHasLoaded = true
                        }
                        
                        self.loadUserData(){userData in
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.user = userData
                            showLoadingAnimation = false
                            //self.leadersHasLoaded = true
                        }
                    }
                
                ForEach(user){user in
                    SelfRankView(hours: user.studyHours)
                            .padding(.top, 20)
                }
                
                Spacer()
                if leaderboardTab.currentDateTab == .allTime{
                    
                    Spacer()
                    if self.leadersHasLoaded {
                    HStack(spacing: 30) {
                        ForEach(leaders){user in
                        LeaderRankView(name: user.name, hours: user.studyHours)
                       // .offset(x: 0, y: 10)
                        
                      
                        }
                        }
                    }
                  
                        VStack(spacing: 30) {
                            ForEach(people){user in
                                
                                LeaderboardRow(name: user.name, hours: user.studyHours)
                                    .onAppear() {
                                        print(user.name)
                                }
                            }
                        
                    
                        } .padding(.top, 22)
                    .padding(.bottom, 110)
                    
                    }
                
                else if leaderboardTab.currentDateTab == .week{
                  Spacer()
                    if self.leadersHasLoaded {
                        HStack(spacing: 30) {
                            ForEach(leadersMonth){user in
                            LeaderRankView(name: user.name, hours: user.month)
                           // .offset(x: 0, y: 10)
                            
                          
                            }
                            }
                    }
                    ScrollView {
                        VStack(spacing: 30) {
                            ForEach(peopleMonth){user in
                                
                                LeaderboardRow(name: user.name, hours: user.month)
                                    .onAppear() {
                                        print(user.name)
                                }
                            }
                        
                    }
                        
                        }
                    
                  
                }
                else if leaderboardTab.currentDateTab == .today{
                    Spacer()
                    HStack(spacing: 30) {
                        ForEach(leadersDay){user in
                        LeaderRankView(name: user.name, hours: user.day)
                       // .offset(x: 0, y: 10)
                        
                      
                        }
                        }
                      ScrollView {
                          VStack(spacing: 30) {
                              ForEach(peopleDay){user in
                                  
                                  LeaderboardRow(name: user.name, hours: user.day)
                                      .onAppear() {
                                          print(user.name)
                                  }
                              }
                          
                      }
                          
                          }
                      
                }
                Spacer(minLength: 120)
            }
            .font(.custom("Montserrat-SemiBold", size: 16))
            .foregroundColor(.white)
            
        
            }
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

struct SelfRankView: View {
    
        var hours:Double
    var body: some View {
        HStack(alignment: .center, spacing: 45){
            VStack {
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.8))
                    .font(.system(size: 13))
               Text("\(Int(hours))")
                    .foregroundColor(.black)
                HStack {
                    Text("Hours")
                        .foregroundColor(.black)
                        .padding(.top, 5)
                    
                }
                
            }
            ProfilePicture(pictureSize: 45)
            
            VStack {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.red)
                Text("96")
                    .foregroundColor(.black)
                Text("Ranking")
                    .foregroundColor(.black)
                    .padding(.top, 5)
            }
        }
        .font(.custom("Montserrat-SemiBold", size: 15))
        .frame(width: 300, height: 100)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        .shadow(radius: 5)
        .opacity(0.7)
    }
}

struct ProfilePicture: View {
    var pictureSize:Int
    
    var body: some View {
        Image("demoprofile")
            .resizable()
            .clipShape(Circle())
            .aspectRatio(contentMode: .fill)
            .frame(width: CGFloat(pictureSize), height: CGFloat(pictureSize))
    }
}

struct LeaderboardRow: View {
    var name:String
     var hours:Double
    var body: some View {
        HStack{
          
            VStack {
                Image(systemName: "arrowtriangle.up.fill")
                    .font(.system(size: 13))
                    .foregroundColor(.green)
                Text("4")
                    .foregroundColor(.black)
            }
            ProfilePicture(pictureSize: 45)
             
            Text(name)
             
                .foregroundColor(.black)
                
            Spacer()
            Text("\(Int(hours))")
                .font(.custom("Montserrat-SemiBold", size: 12))
                .foregroundColor(Color.black.opacity(0.25))
            Image(systemName: "stopwatch.fill")
                .foregroundColor(Color.black.opacity(0.25))
                .offset(x: 0, y: -2)
            
               
        } .padding(.horizontal, 42)
    }
}

struct dateSelectionView: View {
    @Binding var currentDateTab:LeaderBoardTabRouter.tabViews
    
    var body: some View {
        HStack(spacing: 25){
            VStack {
                Text("Today")
                    .foregroundColor(Color.white.opacity(0.25))
                    .onTapGesture {
                        self.currentDateTab = .today
                }
                Rectangle()
                    .fill(currentDateTab == .today ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
                    
            }
            .frame(width: 80)
            VStack {
                Text("Week")
                    .foregroundColor(Color.white.opacity(0.25))
                    .onTapGesture {
                        self.currentDateTab = .week
                }
                Rectangle()
                    .fill(currentDateTab == .week ? Color("primaryYellow") : Color.white.opacity(0))
                    .frame(width: 50, height: 7)
            }
            .frame(width: 80)
            VStack {
                Text("All Time")
                .onTapGesture {
                        self.currentDateTab = .allTime
                }
                Rectangle()
                    .fill(currentDateTab == .allTime ? Color("primaryYellow") :  Color.white.opacity(0) )
                    .frame(width: 50, height: 7)
            }
            .frame(width: 80)
        }
        .animation(.easeInOut)
    }
}

struct LeaderRankView: View {
     var name:String
    var hours:Double
    var body: some View {
        VStack{
            ProfilePicture(pictureSize: 70)
            Text(name)
                .foregroundColor(.black)
                .font(.custom("Montserrat-SemiBold", size: 12))
            HStack {
               Text("\(Int(hours))")
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(Color.black.opacity(0.25))
                Image(systemName: "stopwatch.fill")
                    .foregroundColor(Color.black.opacity(0.25))
                    .offset(x: 0, y: -2)
                
            }
            
        }
    }
}
