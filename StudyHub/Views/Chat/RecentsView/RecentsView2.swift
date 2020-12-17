//
//  RecentsView2.swift
//  StudyHub
//
//  Created by Andreas Ink on 9/25/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct RecentsView2: View {
    @State var allGroups: [Groups] = []
    @State var recentPeople: [User] = []
    @State var recentGroups: [Groups] = []
    var gridItemLayout = [GridItem(.flexible()), GridItem(.flexible())]

    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: ViewRouter
    @State var add: Bool = false
    @State var settings: Bool = false
    @State var showTimer = false
    
    var body: some View {
        ZStack{
            ZStack(alignment: .top) {
                Color("Primary").edgesIgnoringSafeArea(.all)
                VStack {
                    ScrollView{
                        RecentChatTextRow(add: $add)
                        Spacer()
                        if allGroups == []{
                            Text("You are not in any study group yet,\n\nUse the add button to pair. 🙌").font(.custom("Montserrat Bold", size: 24)).foregroundColor(Color(#colorLiteral(red: 0.27, green: 0.89, blue: 0.98, alpha: 1)))
                            .multilineTextAlignment(.center)
                                .frame(width: 250)
                                .frame(height:425)
                        }
                        else{
                            VStack(spacing: 20) {
                                ForEach(recentGroups){group in
                                    RecentGroupRowSubview(group: group, profilePicture: Image("demoprofile"))
                                        .padding(.horizontal, 20)
                                }
                                Spacer()
                            }
                            .frame(height:425)
                            
                        }
                        Spacer()
                        VStack{
                            AllGroupTextRow()
                            
                            LazyVGrid(columns: gridItemLayout, spacing: 40){
                                ForEach(allGroups){group in
                                    RecentChatGroupSubview(group: group)
                                    
                                }
                            }

                        }

                    }
                  
                 
                }
                .frame(width: screenSize.width, height: screenSize.height-150)
                .background(Color("Background"))
                .cornerRadius(20)
                .offset(y: 15)

                
                Header(showTimer: $showTimer)
                   


        }
            if add {
                PairingView(settings: $settings, add: $add, myGroups: $allGroups)

            }
 
        }
        .onAppear {
                    getAllGroups(){self.allGroups=$0}
                    self.getRecentGroups{self.recentGroups=$0}
                    self.recentPeople = getRecentPeople()
                    //downloadImages()
                
            }
        
    }

    
    func loadMessageData(){
        let db = Firestore.firestore()
//        let docRef = db.collection("message/\(group.groupID)/messages").order(by: "sentTime", descending: true).limit(to: 1)
//        docRef.getDocuments{ (document, error) in
//                        if let document = document, !document.isEmpty{
//
//
//                        for document in document.documents{
//
//                                   let result = Result {
//                                       try document.data(as: MessageData.self)
//                                   }
//                                   switch result {
//                                       case .success(let messageData):
//                                           if let messageData = messageData {
//                                            messageArray.append(self.parseMessageData(messageData: messageData))
//                                           } else {
//
//                                               print("Document does not exist")
//                                           }
//                                       case .failure(let error):
//                                           print("Error decoding user: \(error)")
//                                       }
//                  }
//                }
//                        print(messageArray)
//                        self.messages = messageArray
//
//        }
    }
    func getAllGroups(performAction: @escaping ([Groups]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        var allGroups:[Groups] = []

        queryParameter.addSnapshotListener{ (querySnapshot, error) in
            guard querySnapshot != nil else {
                print("Empty snapshot")
                return}
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: Groups.self)
                }
                switch result {
                    case .success(let user):
                        if let user = user {
                            if !allGroups.contains(user){
                                allGroups.append(user)
                            }

                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
            }
            performAction(allGroups)
        }
    }
    func getRecentGroups(performAction: @escaping ([Groups]) -> Void){
        var recentGroups:[Groups] = []
        getCurrentOrAnyUser(){user in
            if let groups = user.recentGroups{
                for id in groups{
                    getGroups(groupID: id){group in
                        if !recentGroups.contains(group){
                            recentGroups.append(group)
                        }
                        performAction(recentGroups)
                    }
                }
            }
        }
    }
    func getRecentPeople() -> [User]{
        var recentPeople:[User] = []
        getCurrentOrAnyUser(){user in
            if let people = user.recentPeople{
                for id in people{
                    getCurrentOrAnyUser(userID: id){user in
                        recentPeople.append(user)
                    }
                  
                }
            }
        }
        return recentPeople
    }
    
    func getCurrentOrAnyUser(userID: String?=nil, performAction: @escaping (User) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userID ?? userData.userID)
        docRef.addSnapshotListener{document, error in
            let result = Result{
                try document?.data(as: User.self)
            }
            switch result{
            case .success(let user):
                if let user=user{
                    performAction(user)
                }
                else{
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding group: \(error)")
            }

        }
    }
    
    func getGroups(groupID:String, performAction: @escaping (Groups) -> Void){
        let db = Firestore.firestore()
        let ref = db.collection("groups").document(groupID)
        ref.addSnapshotListener{ (document, error) in
                let result = Result {
                    try document?.data(as: Groups.self)
                }
                switch result {
                    case .success(let group):
                        if let group = group {
                            performAction(group)

                        } else {
                            print("Document does not exist")
                        }
                    case .failure(let error):
                        print("Error decoding user: \(error)")
                    }
        }
     
    }

//    func downloadImages(for userID:String) -> Image? {
//        let metadata = StorageMetadata()
//        metadata.contentType = "image/jpeg"
//
//        let storage = Storage.storage()
//        let pathReference = storage.reference(withPath: userData.userID)
//
//       // gs://study-hub-7540b.appspot.com/images
//        pathReference.getData(maxSize: 1 * 500 * 500) { data, error in
//          if let error = error {
//            print(error)
//            // Uh-oh, an error occurred!
//          } else {
//            // Data for "images/island.jpg" is returned
//            var image = UIImage(data: data!) ?? nil
//            return Image(uiImage: image!)
//
//
//          }
//        }
//    }
        
        
    }

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


