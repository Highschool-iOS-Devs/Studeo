//
//  MemberProfileSubview.swift
//  StudyHub
//
//  Created by Jevon Mao on 12/24/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//
//
//import SwiftUI
//import KingfisherSwiftUI
//import Firebase
//import FirebaseFirestore
//import FirebaseFirestoreSwift
//import Alamofire
//import struct Kingfisher.DownsamplingImageProcessor
//import struct Kingfisher.ImageResource
//import class Kingfisher.ImageCache
//
//struct MemberProfileSubview: View {
//    //@Binding var groups:Groups
//    @Binding var nameAndProfiles:[NameAndProfileModel]
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false){
//            HStack(alignment:.center, spacing:10){
//                ForEach(nameAndProfiles, id:\.self){user in
//                    VStack{
//                        KFImage(user.imageURL, options: [.transition(.fade(0.5)), .processor(DownsamplingImageProcessor(size: CGSize(width: 60, height: 60))), .cacheOriginalImage])
//                            .placeholder{
//                                Image("demoprofile")
//                            }
//                            .onSuccess { r in
//                                 // r: RetrieveImageResult
//                                 print("success: \(r)")
//                             }
//                             .onFailure { e in
//                                 // e: KingfisherError
//                                 print("failure: \(e)")
//                             }
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width:50, height:50)
//                            .clipShape(Circle())
//                            .overlay(Circle().stroke(Color("Background"), lineWidth: 1))
//                            .animation(.easeInOut)
//                            .transition(.opacity)
//                        Text(user.name)
//                            .font(.custom("Montserrat-Semibold", size: 16))
//                            .padding(.top, 5)
//                    }
//                    .frame(width:100, height:100)
//                    .background(Color("Background"))
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                    .shadow(color: Color("Primary").opacity(0.3), radius: 10, x: 0, y: 5)
//                }
//            }
//
//        }
//
//        .padding(.top,10)
//        .padding(.horizontal, 10)
//
//
//    }
//
    
// func loadMembers(performAction: @escaping ([User]?) -> Void) {
//     let db = Firestore.firestore()
//    for memberID in groups.members{
//
//    }
//     let docRef = db.collection("users")
//     var groupList:[User] = []
//     //Get every single document under collection users
//
//     docRef.getDocuments{ (querySnapshot, error) in
//         if let querySnapshot = querySnapshot,!querySnapshot.isEmpty{
//         for document in querySnapshot.documents{
//             let result = Result {
//                 try document.data(as: User.self)
//             }
//             switch result {
//                 case .success(let group):
//                     if var group = group {
//
//                         groupList.append(group)
//
//                     } else {
//
//                         print("Document does not exist")
//                     }
//                 case .failure(let error):
//                     print("Error decoding user: \(error)")
//                 }
//
//
//         }
//         }
//         else{
//             performAction(nil)
//         }
//           performAction(groupList)
//     }
//
//
// }
//}
//
//struct NameAndProfileModel:Equatable, Hashable{
//    var name:String
//    var imageURL:URL
//}
//
