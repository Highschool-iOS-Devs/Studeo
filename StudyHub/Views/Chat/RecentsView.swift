////
////  ChatList.swift
////  StudyHub
////
////  Created by Andreas Ink on 8/29/20.
////  Copyright © 2020 Dakshin Devanand. All rights reserved.
////
//
//import SwiftUI
//import Firebase
//struct ChatList: View {
//    @State var people = [ChattedWith]()
//    @State var person = ChattedWith(id: "", name: "", count: 0, chatRoom: "")
//    @EnvironmentObject var userData: UserData
//    @State var hasData = false
//    @State var tapped = false
//    @State var add = false
//    @State var auth = false
//    @State var personCount = -1
//    @State var chatRoom = [""]
//    @State var userIDs = [""]
//    @State private var activeSheet: ActiveSheet = .first
//    enum ActiveSheet {
//        case first, second
//    }
//    var body: some View {
//        ZStack {
//            Color(.white)
//                .onAppear() {
//                    
//                    self.personCount = -1
//                    
//                    self.hasData = false
//                    self.people.removeAll()
//                    self.chatRoom.removeAll()
//                    print(Auth.auth().currentUser?.uid)
//                    if Auth.auth().currentUser?.uid == nil {
//                        self.auth = true
//                    } else {
//                        
//                        self.loadData()
//                    }
//            }
//            
//            
//            
//            
//            if self.auth {
//                Color(.white)
//                RegistrationView()
//            }
//            if Auth.auth().currentUser?.uid != nil {
//                if hasData {
//                    Color(.white)
//                    List {
//                        ForEach(people, id: \.id) { person in
//                            
//                            Group {
//                                
//                                HStack {
//                                    Text(person.name)
//                                        .padding(.top, 42)
//                                        .onTapGesture {
//                                            
//                                            
//                                    }
//                                    Spacer()
//                                }
//                                
//                                
//                            }
//                            
//                        }
//                        
//                    }
//                    .sheet(isPresented: $tapped) {
//                        if self.activeSheet == .first {
//                            AddChat()
//                                .environmentObject(UserData.shared)
//                        }
//                        else if self.activeSheet == .second {
//                            ChatV2(matchedPerson: self.person.name, chatRoom: self.person.chatRoom)
//                                .environmentObject(UserData.shared)
//                        }
//                    }
//                    VStack {
//                        
//                        HStack {
//                            Spacer()
//                            Button(action: {
//                                self.activeSheet = .first
//                                self.tapped.toggle()
//                            }) {
//                                
//                                ZStack {
//                                    Circle()
//                                        .foregroundColor(.black)
//                                    Image("add")
//                                        .resizable()
//                                        .renderingMode(.original)
//                                        .frame(width: 20, height: 20, alignment: .center)
//                                        .scaledToFit()
//                                }  .frame(width: 50, height: 50, alignment: .center)
//                            }
//                            
//                        }
//                        Spacer()
//                    } .padding(12)
//                    
//                    
//                }
//            }
//            
//            
//        }
//    }
//    func loadData() {
//        
//    }
//    
//    
//    //   print(self.index)
//}
//
//
//
