//
//  SettingView.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
let screenSize = UIScreen.main.bounds.size

struct SettingView: View {
     @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: ViewRouter
     @State var settings = [SettingsData]()

    @State private var hasCheckedAuth = false
    var body: some View {
        ZStack {
            Color(.white)
                .onAppear() {
                    self.checkAuth()
                    self.loadData(){userData in
                        //Get completion handler data results from loadData function and set it as the recentPeople local variable
                        
                        self.settings = userData
                        
                        
                    }
                    
            }
            
            ScrollView {
                VStack {
                    VStack {
                    profilePictureCircle()
                    Text(self.userData.name)
                    .font(.custom("Montserrat-Bold", size: 28))
                    .padding(.top, 10)
                }
               
                
                Spacer(minLength: 75)
                
                VStack(alignment:.leading) {
                    
                    Text("Account Settings")
                        .font(.custom("Montserrat-Bold", size: 16))
                        .foregroundColor(.black)
                        .padding(.bottom, 25)
                        .padding(.top, 40)
                        .padding(.horizontal, 22)
                   ScrollView {
                    VStack(spacing: 30) {
                        ForEach(settings){setting in
                       
                            settingRowView(settingText: setting.name, settingState: setting.state)
                       
                        
                        }
                        
                        settingRowView(settingText: "Sign out", settingState: "")
                             Spacer()
                            .onTapGesture {
                                FirebaseManager.signOut()
                                self.viewRouter.updateCurrentView(view: .registration)
                                
                        }
                            
                        settingRowView(settingText: "Help", settingState: "")
                        
                    }
                    }
                    Spacer()
                }
                    
                    
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(radius: 5)
                .padding(.horizontal, 10)

            } .padding(.bottom, 85)
        }
    }
    }
        
        func loadData(performAction: @escaping ([SettingsData]) -> Void){
            if hasCheckedAuth {
               let db = Firestore.firestore()
                let docRef = db.collection("settings").document(self.userData.userID)
               var userList:[SettingsData] = []
               //Get every single document under collection users
               docRef.getDocument{ (document, error) in
                   
                       let result = Result {
                        try document!.data(as: SettingsData.self)
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
           
        func checkAuth(){
            DispatchQueue.global(qos: .background).async {
                Auth.auth().addStateDidChangeListener { (auth, user) in
                    print(user)
                    if user != nil{
                        self.viewRouter.currentView = .home
                        self.hasCheckedAuth = true
                    }
                    else {
                        self.viewRouter.currentView = .registration
                        self.hasCheckedAuth = true
                    }
                   
                }
            }
             
        }
    
    
    struct SettingView_Previews: PreviewProvider {
        static var previews: some View {
            SettingView()
        }
    }
    
    struct profilePictureCircle: View {
        var body: some View {
            Circle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 52, height: 52)
                .overlay(
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.gradientLight, Color.gradientDark]), startPoint: .top, endPoint: .bottom))
                        .frame(width: 50, height: 50)
                        .overlay(Image("demoprofile")
                            
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 45, height: 45)
                            
                    )
            )
        }
    }
    
    struct settingRowView: View {
        var settingText:String
        var settingState:String
        
        var body: some View {
            HStack{
                Text(settingText)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .opacity(0.4)
                    
                Spacer()
                
                Text(settingState)
                    .frame(width: 50)
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .lineLimit(1)
                    .opacity(0.4)
                    .padding(.trailing, 5)
                
                Image(systemName: "chevron.right")
                    .font(Font.system(size: 13).weight(.semibold))
                
                
                
            } .padding(.horizontal, 22)
           
            
        }
    }
}
