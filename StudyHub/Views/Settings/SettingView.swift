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
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var viewRouter: ViewRouter
    @State private var userSettings = SettingsData(settings: [])
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
    var body: some View {
            NavigationView {
                ZStack {
                    ScrollView {
                        VStack {
                            VStack {
                                ProfileRingView(size: 100)
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
                                    //    .environmentObject(userData)
                                    settingRowView(settingText: "Notifications", settingState: ((!chatNotifications && !newGroupNotifications) ? "Off" : "On"), newView: AnyView(NotificationsView(chatNotifications: $chatNotifications, groupNotifications: $newGroupNotifications)))
                                    settingRowView(settingText: "Personal info", settingState: "", newView: AnyView(PersonalInfoView()))
                                    settingRowView(settingText: "Country", settingState: country, newView: AnyView(CountrySelectionView(selectedCountry: $country)))
                                    settingRowView(settingText: "Language", settingState: language, newView: AnyView(LanguageSelectionView(selectedLanguage: $language)))
                                    settingRowView(settingText: "Interests", settingState: "", newView: AnyView(IntroCustomize(interestSelected: $interestSelected, isNotOnboarding: true, interests: $interests, settings: $settings, add: $add)))
                                    settingRowView(settingText: "Sign out", settingState: "", newView: AnyView(Text("Placeholder")), disableNavigation: true)
                                        .onTapGesture(){
                                            signOut()
                                            resetUserDefaults()
                                            removeAllPendingNotifications()
                                            KingfisherManager.shared.cache.clearCache()
                                            viewRouter.updateCurrentView(view:.login)
                                        }
                                    settingRowView(settingText: "Help", settingState: "", newView: AnyView(Text("")), disableNavigation: true)
                                        .onTapGesture {
                                            self.showHelp = true
                                        }
                                }
                                Spacer()
                            }
                            .padding(.bottom, 20)
                            .background(Color("Background"))
                            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                            .shadow(color: Color("shadow") ,radius: 5)
                            .padding(.horizontal, 10)
                            Spacer(minLength: 120)
                        }
                        .padding(.top, 50)
                    }
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
                        self.userSettings = SettingsData.defaultSettings
                    }
                    updateUIWithData(self.userSettings)
                }
            }
            .onDisappear{
                print("Settings disappeared, save data now.")
                self.saveAvailability() { error in
                    if let error = error {
                        //do something
                    }
                }
                self.saveData()
                monitor.cancel()
            }
        
        
        
        
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
    
    func updateNewSettings() {
        var newSettings = [SettingSubData]()
        for settings in self.userSettings.settings {
            switch settings.name {
            case "Country":
                newSettings.append(SettingSubData(name: settings.name, field: self.country))
            case "Chat notifications":
                newSettings.append(SettingSubData(name: settings.name, state: self.chatNotifications))
            case "New group notifications":
                newSettings.append(SettingSubData(name: settings.name, state: self.newGroupNotifications))
            case "Personal info":
                newSettings.append(SettingSubData(name: settings.name, state: true))
            case "Language":
                newSettings.append(SettingSubData(name: settings.name, field: self.language))
            default:
                print("Unexpected setting with name: \(settings.name)")
            }
        }
        self.userSettings.settings = newSettings
    }
    
    func saveData() {
        updateNewSettings()
        let db = Firestore.firestore()
        let ref = db.collection("settings").document(userData.userID)
        do {
            try ref.setData(from: self.userSettings)
            self.userData.chatNotificationsOn = chatNotifications
            self.userData.joinedGroupNotificationsOn = newGroupNotifications
        } catch let error {
            print("Error writing settings to firestore: \(error)")
        }
    }
    
    func updateUIWithData(_ data: SettingsData) {
        for settings in data.settings {
            switch settings.name {
            case "Country":
                self.country = settings.field!
            case "Chat notifications":
                self.chatNotifications = settings.state!
            case "New group notifications":
                self.newGroupNotifications = settings.state!
            case "Language":
                self.language = settings.field!
            default:
                print("Unexpected setting with name: \(settings.name)")
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
        var newView: AnyView
        var disableNavigation:Bool = false
        var body: some View {
                HStack{
                    NavigationLink(destination: newView) {
                        Text(settingText)
                            .font(.custom("Montserrat-SemiBold", size: 12))
                            .foregroundColor(Color("Text"))
                            .opacity(0.9)
                            .padding()
                        
                        Spacer()
                        Text(settingState)
                            .font(.custom("Montserrat-SemiBold", size: 12))
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
    @EnvironmentObject var userData: UserData
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


