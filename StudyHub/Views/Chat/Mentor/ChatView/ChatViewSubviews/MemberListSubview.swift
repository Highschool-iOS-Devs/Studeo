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
                    HStack(alignment: .center){
                        ForEach(members) { member in
                            if member.id.uuidString != self.userData.userID{
                                VStack {
                                   ProfileRingView(imagePlaceholder: Image("person"), size: 75)
                                Text(member.name)
                                    .minimumScaleFactor(0.001)
                                    .font(.custom("Montserrat-Semibold", size: 15))
                                    .foregroundColor(Color("Text"))
                                    .padding(.top, 10)
                                    .lineLimit(1)

                                }
                                .frame(maxWidth:.infinity)
                                .padding(.top, 20)
                                .onTapGesture {
                                    self.member = member
                                    showFull = true
                                }
                            }

                           
                        }
                    }
                }
                else{
                    LazyVGrid(columns: columns){
                        ForEach(members) { member in
                            if member.id.uuidString != self.userData.userID{
                                VStack {
                                    ProfileRingView(imageURL:member.profileImageURL ?? nil, size: 75)
                                Text(member.name)
                                    .minimumScaleFactor(0.001)
                                    .font(.custom("Montserrat-Semibold", size: 15))
                                    .foregroundColor(Color("Text"))
                                    .padding(.top, 10)
                                    .lineLimit(1)

                                }
                                .frame(maxWidth:.infinity)
                                .padding(.top, 20)
                                .onTapGesture {
                                    self.member = member
                                    showFull = true
                                }

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
        .onAppear{
            for index in 0..<members.count{
                downloadImages(for: members[index].id.uuidString){
                    members[index].profileImageURL = $0
                }
                
            }
        }

   
    }
    func downloadImages(for userID:String, completion: @escaping (URL) -> Void){
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let storage = Storage.storage()
        let pathReference = storage.reference(forURL: "gs://study-hub-7540b.appspot.com/User_Profile/\(userID)")
        pathReference.downloadURL { url, error in
            if let error = error {
                print("Error downloading image, \(error)")
            } else {
                completion(url!)
            }
        }
        
    }

}


