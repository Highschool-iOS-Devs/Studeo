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

//Currently recent view will display all users because chatting is not set up yet
struct RecentsView2: View {
    //List for UI displaying the list of people
    @Binding var recentPeople: [Groups]
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: ViewRouter
    @State var add: Bool = false
    //For passing information into chat view. When user taps on a people in the scroll list, it should take user to the chat view.
    @State var myGroups = [Groups]()
    @State var settings: Bool = false
    @Binding var images: [UIImage]
    var body: some View {
        ZStack {
            
            VStack {
                
                HStack {
                    Button(action: {
                   
                        
                        self.loadData(){ userData in
                            recentPeople.removeAll()
                            images.removeAll()
                            //Get completion handler data results from loadData function and set it as the recentPeople local variable
                            self.recentPeople = userData
                            print("myGroups now has \(myGroups.count) groups")
                            downloadImages()
                        }
                            
                        
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .font(.largeTitle)
                    }
                    Spacer()
                    Button(action: {
                   
                            add.toggle()
                        
                    }) {
                        Image(systemName: "plus")
                            .font(.largeTitle)
                    }
                   
                }
                Spacer()
            }.padding()
            
            VStack {
                Text("Recent Chats")
                    .font(.custom("Montserrat-Bold", size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 15)
                    .padding(.vertical, 30)
                ScrollView(showsIndicators: false) {
                ForEach(recentPeople){user in
                    
//                    ForEach(images, id: \.self) { image in
                    RecentPersonView(name: user.groupName, group: user, image: UIImage(systemName: "person")!)
                        .environmentObject(userData)
                        .onTapGesture {
                            
                    }
//                }
                }
                    Spacer(minLength: 150)
                }
                
                Spacer()
            }
           
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
                .offset(x: 0, y: 50)
             
        
        
        
        if add {
            PairingView(settings: $settings, add: $add, myGroups: $myGroups)
                .onDisappear {
                    self.loadData(){ userData in
                        recentPeople.removeAll()
                        images.removeAll()
                        //Get completion handler data results from loadData function and set it as the recentPeople local variable
                        self.recentPeople = userData
                        self.myGroups = userData
                        print("myGroups now has \(myGroups.count) groups")
                        downloadImages()
                    }
                }
          
        }
    }
        .onAppear {
            self.loadData(){ userData in
                recentPeople.removeAll()
                images.removeAll()
                //Get completion handler data results from loadData function and set it as the recentPeople local variable
                self.recentPeople = userData
                self.myGroups = userData
                print("myGroups now has \(myGroups.count) groups")
                downloadImages()
            }
        }
    }
            
    func loadData(performAction: @escaping ([Groups]) -> Void){
        let db = Firestore.firestore()
        let docRef = db.collection("groups")
        var userList:[Groups] = []
        //Get every single document under collection users
        let queryParameter = docRef.whereField("members", arrayContains: userData.userID)
        queryParameter.getDocuments{ (querySnapshot, error) in
            for document in querySnapshot!.documents{
                let result = Result {
                    try document.data(as: Groups.self)
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
    
    func downloadImages() {
        for people in myGroups {
            print(0)
            for members in people.members {
                print(1)
            let db = Firestore.firestore()
                let docRef = db.collection("users").document(members)

            docRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                } else {
                    print("Document does not exist")
                }
            }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        let storage = Storage.storage()
        let pathReference = storage.reference(withPath: userData.userID)
       
       // gs://study-hub-7540b.appspot.com/images
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        pathReference.getData(maxSize: 1 * 5000 * 5000) { data, error in
          if let error = error {
            print(error)
            // Uh-oh, an error occurred!
          } else {
            // Data for "images/island.jpg" is returned
            var image = UIImage(data: data!)
            images.append(image!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            //showLoadingAnimation = false
            }
          }
        }
            }
        }
        
    }
}
