//
//  MembersList.swift
//  StudyHub
//
//  Created by Andreas on 12/20/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase

struct MemberListSubview: View {
    @Binding var members: [User]
    @Binding var memberList: Bool
    @Binding var showFull:Bool
    @Binding var group: Groups
    @Binding var person: User
    @EnvironmentObject var userData:UserData
    @State var member:User?
    @Binding var messages: [MessageData]
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    var body: some View {
        ZStack{
            VStack {
                HStack {
               
                    Spacer()
                    
                    Text(group.groupName)
                        .foregroundColor(Color("Primary"))
                        .font(.custom("Montserrat-Bold", size: 28))
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack{
                   Text("Tap on a member to view detail")
                    .foregroundColor(Color("Primary"))
                    .font(.custom("Montserrat-SemiBold", size: 15))

                }
                .padding(.top, 5)
                .padding(.bottom, 2)
                HStack{
                    Spacer()
                    Text("\(group.membersCount) studymates")
                        .foregroundColor(Color("Secondary"))
                        .font(.custom("Montserrat-SemiBold", size: 15))

                    
                    Spacer()
                }
                if members.count <= 4{
                    HStack(alignment: .center, spacing: 20){
                        ForEach(members) { member in
                                VStack {
                                   ProfileRingView(imagePlaceholder: Image("person"), size: 75)
                                Text(member.name)
                                    .minimumScaleFactor(0.001)
                                    .font(.custom("Montserrat-Semibold", size: 15))
                                    .foregroundColor(Color("Text"))
                                    .padding()
                                    .lineLimit(1)
                                    .frame(width:100)

                                }
                                .onTapGesture {
                                    self.member = member
                                    showFull = true
                                }

                           
                        }
                    }
                }
                else{
                    LazyVGrid(columns: columns, spacing: 20){
                        ForEach(members) { member in
                                VStack {
                                   ProfileRingView(imagePlaceholder: Image("person"), size: 75)
                                Text(member.name)
                                    .minimumScaleFactor(0.001)
                                    .font(.custom("Montserrat-Semibold", size: 15))
                                    .foregroundColor(Color("Text"))
                                    .padding()
                                    .lineLimit(1)
                                    .frame(width:100)



                                }
                                .onTapGesture {
                                    self.member = member
                                    showFull = true
                                }

                           
                        }
                    }
                }
      
    
                Spacer()
            }
            if showFull{
                withAnimation(Animation.easeInOut.speed(0.8)){
                    ZStack{
                        OtherUserProfileView(user: member!, showMemberList: $memberList)
                        VStack{
                            HStack{
                                Button(action: {
                                    showFull = false
                                    
                                }) {
                                    Image(systemName: "xmark")
                                        .foregroundColor(Color("Primary"))
                                }
                                .padding()
                               Spacer()
                            }
                            Spacer()
                        }
                  
                    }
                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
                
                }
               

            }
        
        }

   
    }

}


//                        NavigationLink(destination: OtherUserProfileView(user: member, showMemberList: $memberList), tag: members.firstIndex(of: member)!, selection:$action){
//                                EmptyView()
//                            }.navigationBarHidden(true)
                        
