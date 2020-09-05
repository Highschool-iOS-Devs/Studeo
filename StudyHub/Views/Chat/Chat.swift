//
//  Chat.swift
//  StudyHub
//
//  Created by Andreas Ink on 8/29/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
import SwiftUI
import Firebase

struct ChatV2: View {
    @State var matchedPerson = ""
    @State var chatRoom = ""
    @State var matchedPersonID = ""
    @State var chat = [ChatData]()
    @State var i = 0
    @State var total = -1
    @State var hasAppeared = false
    @State var hasMessage = false
    @State var message = "Message"
    @State var goBack = false
    @State var add = false
    @State var testing = true
    @State var testName = ""
    @State var currentOffset = 0
    @State var scrollOffset = 0
    @State var addChat = false
    
    @EnvironmentObject var userData: UserData
    var body: some View {
        
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(.all)
                
                
                .onAppear() {
                   // self.chat.removeAll()
                    self.i = 0
                    self.total = -1
                    withAnimation() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.loadData()
                        }
                    }
            }
            
            VStack {
                
                
                Text(matchedPerson)
                    .font(.title)
                    .padding(.top, 22)
                Spacer()
            }
            VStack {
                  if self.hasAppeared {
               ReverseScrollView(scrollOffset: CGFloat(self.scrollOffset), currentOffset: CGFloat(self.currentOffset)) {
                    
                   
                        VStack {
                           
                            
                            
                            ForEach(self.chat, id: \.id) { chating in
                                Group {
                                    
                                    if !chating.isMe {
                                        ChatV2Cell2(name: chating.name, message: chating.message)
                                            .padding(.top, 62)
                                            .padding(.horizontal, 12)
                                    }
                                    if chating.isMe {
                                        
                                        ChatV2Cell(name: chating.name, message: chating.message)
                                            .padding(.top, 62)
                                            .padding(.horizontal, 12)
                                        
                                    }
                                    
                                    
                                }
                            }
                            
                        }
                    }
                    
                }
            
                Spacer()
                Divider()
                HStack {
                    
                    TextField("Message", text: $message)
                        .foregroundColor(.gray)
                        .frame(height: 50)
                        .onTapGesture {
                            self.message = ""
                    }
                    Spacer()
                    Ellipse()
                        .foregroundColor(Color(.systemBlue))
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                           
                    }
                } .padding([.trailing, .leading], 12)
                    .padding(.bottom, 22)
            }
            
        }
    }
    func loadData() {
      
    }
}
