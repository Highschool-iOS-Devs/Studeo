//
//  SettingView.swift
//  StudyHub
//
//  Created by Jevon Mao on 8/22/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import FirebaseFirestore
import Network
import UserNotifications
import SupportDocs
import class Kingfisher.KingfisherManager
let screenSize = UIScreen.main.bounds.size

struct SettingView: View {
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter: ViewRouter
    @State private var userSettings = SettingsData()
    @State private var userIsAvailable = true
    
    
    @State private var chatNotifications = true
    @State private var newGroupNotifications = true
    @State private var country = ""
    @State private var language = ""
    
    @State private var showHelp = false
    let dataSource = URL(string: "https://raw.githubusercontent.com/Highschool-iOS-Devs/Studeo-Help/DataSource/_data/supportdocs_datasource.json")!
    @State var interestSelected: [UserInterestTypes] = []
    @State var settings = false
    @State var interests = [String]()
    @State var add = false
    @State private var signingOut = false
    @State private var showConfirmationAlert = false
    
    var body: some View {
            NavigationView {
                ZStack {
                    ScrollView(showsIndicators: false) {
                        VStack {
                            VStack {
                                ProfileRingView(size: 100, userData: userData)
                                Text(userData.name)
                                .font(.custom("Montserrat-Bold", size: 28))
                                .padding(.top, 10)
                                .foregroundColor(Color("Text"))
                            }.padding(.top, 20)
                           
                            
                            Spacer(minLength: 50)
                            
                            VStack(alignment:.leading) {
                                
                                Text("Account Settings")
                                    .font(.custom("Montserrat-Bold", size: 20))
                                    .foregroundColor(Color("Text"))
                                    .padding(.bottom, 40)
                                    .padding(.top, 40)
                                    .padding(.horizontal, 22)
                                VStack(spacing: 30) {
                                    availabilityRowView(settingText: "Available for new pairings", userAvailable: $userIsAvailable)
                                   // appearanceRowView()
                                    //    
                                    settingRowView(settingText: "Notifications", settingState: ((!chatNotifications && !newGroupNotifications) ? "Off" : "On"), newView: AnyView(NotificationsView(userData: userData, chatNotifications: $chatNotifications, groupNotifications: $newGroupNotifications)))
                                    settingRowView(settingText: "Personal info", settingState: "", newView: AnyView(PersonalInfoView(userData: userData)))
                                    settingRowView(settingText: "Country", settingState: country, newView: AnyView(CountrySelectionView(userData: userData, selectedCountry: $country)))
                                    settingRowView(settingText: "Language", settingState: language, newView: AnyView(LanguageSelectionView(userData: userData, selectedLanguage: $language)))
                                    settingRowView(settingText: "Interests", settingState: "", newView: AnyView(IntroCustomize(interestSelected: $interestSelected, userData: userData, isNotOnboarding: true, interests: $interests, settings: $settings, add: $add, viewRouter: viewRouter)))
                                    settingRowView(settingText: "Sign out", settingState: "", newView: AnyView(Text("Placeholder")), disableNavigation: true)
                                        .onTapGesture(){
                                            saveData()
                                            signingOut = true
                                            signOut()
                                            resetUserDefaults()
                                            removeAllPendingNotifications()
                                            KingfisherManager.shared.cache.clearCache()
                                            viewRouter.updateCurrentView(view:.login)
                                        }
                                    settingRowView(settingText: "Delete Account", settingState: "", newView: AnyView(Text("Placeholder")), disableNavigation: true, destructive: true)
                                        .onTapGesture(){
                                            showConfirmationAlert = true
                                        }
                                  //  settingRowView(settingText: "Help", settingState: "", newView: AnyView(Text("")), disableNavigation: true)
                                   //     .onTapGesture {
                                    //        self.showHelp = true
                                     //   }
                                }
                                Spacer()
                            }
                           
                            .background(Color("Background"))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .shadow(color: Color("shadow") ,radius: 5)
                            .padding(.horizontal, 10)
                            
                        }
                        .padding(.top, 50)
                    Spacer(minLength: 200)
                }
                .background(Color("Background"))
                .edgesIgnoringSafeArea(.all)
                .navigationBarTitle("")
                .navigationBarHidden(true)
                .sheet(isPresented: $showHelp) {
                    SupportDocsView(dataSourceURL: dataSource)
                }
            }
            .onAppear {
                self.loadAvailabilityData()
                self.loadSettingsData { (data) in
                    if let settingsData = data {
                        self.userSettings = settingsData
                    } else {
                        self.userSettings = SettingsData(id: UUID(uuidString: userData.userID)!)
                    }
                    updateUIWithData(self.userSettings)
                }
            }
            .onDisappear{
                guard signingOut == false else { return }
                print("Settings disappeared, save data now.")
                self.saveAvailability() { error in
                    if let error = error {
                        //do something
                    }
                }
                self.saveData()
                monitor.cancel()
            }
            .alert(isPresented: $showConfirmationAlert, content: {
                Alert(title: Text("Are you sure?"), message: Text("This action cannot be undone"), primaryButton: .destructive(Text("Confirm"), action: {
                   
                   
                    resetUserDefaults()
                    removeAllPendingNotifications()
                    KingfisherManager.shared.cache.clearCache()
                    viewRouter.currentView = .introView
                    FirebaseManager.deleteUser(userID: userData.userID) { error in
                        guard error == nil else {
                            print(error?.localizedDescription)
                            return
                        }
                        userData.userID = UUID().uuidString
                        signingOut = true
                    }
                }), secondaryButton: .cancel())
            })
        
            }
            .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func resetUserDefaults() {
        let defaults = UserDefaults.standard
        let dict = defaults.dictionaryRepresentation()
        dict.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    func signOut() {
        self.userIsAvailable = false
        saveAvailability { error in
            if error == nil {
                FirebaseManager.signOut()
            }
        }
    }
    
    func removeAllPendingNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func saveAvailability(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userData.userID)
        
        ref.updateData(["isAvailable" : userIsAvailable]) { error in
            guard let error = error else {
                completion(nil)
                return
            }
            print("Error updating data: \(error)")
            completion(error)
        }
    }
    
    func loadAvailabilityData() {
        let db = Firestore.firestore()
        let ref = db.collection("users").document(userData.userID)
        ref.getDocument { snapshot, error in
            guard let snapshot = snapshot else {
                print("Error loading data: \(error)")
                return
            }
            let data = snapshot.data()?["isAvailable"] as? Bool
            
            self.userIsAvailable = data ?? false
        }
    }
    
    func loadSettingsData(completion: @escaping (SettingsData?) -> Void) {
        let db = Firestore.firestore()
        let ref = db.collection("settings").document(userData.userID)
        ref.getDocument { (document, error) in
            if let document = document {
            let result = Result {
                try document.data(as: SettingsData.self)
            }
                switch result {
                case .success(let settings):
                    print("Success decoding settings")
                    completion(settings)
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
        
    }
    
    func saveData() {
        self.userSettings = SettingsData(id: UUID(uuidString: userData.userID)!, country: self.country, chatNotifications: self.chatNotifications, newGroupNotifications: self.newGroupNotifications, language: self.language)
        let db = Firestore.firestore()
        let ref = db.collection("settings").document(userData.userID)
        do {
            try ref.setData(from: self.userSettings, merge: true)
            self.userData.chatNotificationsOn = chatNotifications
            self.userData.joinedGroupNotificationsOn = newGroupNotifications
        } catch let error {
            print("Error writing settings to firestore: \(error)")
        }
    }
    
    func updateUIWithData(_ data: SettingsData) {
//        for settings in data.settings {
//            switch settings.name {
//            case "Country":
//                self.country = settings.field!
//            case "Chat notifications":
//                self.chatNotifications = settings.state!
//            case "New group notifications":
//                self.newGroupNotifications = settings.state!
//            case "Language":
//                self.language = settings.field!
//            default:
//                print("Unexpected setting with name: \(settings.name)")
//            }
//        }
        self.country = data.country
        self.chatNotifications = data.chatNotifications
        self.newGroupNotifications = data.newGroupNotifications
        self.language = data.language
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
        var newView: AnyView
        var disableNavigation:Bool = false
        var destructive = false
        var body: some View {
                HStack{
                    NavigationLink(destination: newView) {
                        Text(settingText)
                            .font(Font.custom("Montserrat-SemiBold", size: 12, relativeTo: .subheadline))
                            .foregroundColor(destructive ? Color.red : Color("Text"))
                            .opacity(0.9)
                            .padding()
                        
                        Spacer()
                        Text(settingState)
                            .font(Font.custom("Montserrat-SemiBold", size: 12, relativeTo: .subheadline))
                            .lineLimit(1)
                            .foregroundColor(Color("Text"))
                            .opacity(0.4)
                            
                        if !disableNavigation {
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color("barCenter"))
                            .font(Font.system(size: 13).weight(.semibold))
                            .padding()
                        }
                    }.disabled(disableNavigation)
                    
                }
            
            
           
            
        }
    }
    
    struct availabilityRowView: View {
        var settingText: String
        @Binding var userAvailable: Bool
        var body: some View {
                HStack{
                    Text(settingText)
                        .font(.custom("Montserrat-SemiBold", size: 12))
                        .foregroundColor(Color("Text"))
                        .opacity(0.9)
                        .padding()
                    Spacer()
                    
                    Toggle("Availability for pairing", isOn: $userAvailable)
                        .labelsHidden()
                        .padding()
                }
            
            
           
            
        }
    }

struct appearanceRowView: View {
    @ObservedObject var userData: UserData
    var body: some View {
            HStack{
                Text("Dark Mode")
                    .font(.custom("Montserrat-SemiBold", size: 12))
                    .foregroundColor(Color("Text"))
                    .opacity(0.9)
                    .padding()
                Spacer()
                
                Toggle("Dark Mode", isOn: $userData.darkModeOn)
                    .labelsHidden()
                    .padding()
            }
        
        
       
        
    }
}


