//
//  IntroPage4.swift
//  StudyHub
//
//  Created by Jevon Mao on 9/17/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseCore

func hapticEngine(style: UIImpactFeedbackGenerator.FeedbackStyle){
    let impact = UIImpactFeedbackGenerator(style: .medium)
    impact.impactOccurred()
}

struct IntroCustomize: View {
    @Binding var interestSelected: [UserInterestTypes]
    @EnvironmentObject var userData: UserData
    @State var isNotOnboarding: Bool = false
    @Binding var interests: [String]
    @Binding var settings: Bool
    @Binding var add: Bool
    @EnvironmentObject var viewRouter:ViewRouter
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
                .onAppear() {
                  
                }
            VStack {
                if !isNotOnboarding {
        
            HStack {
                Button(action: {
                   
                    if !settings {
                        add = false
                    }
                    if settings {
                        settings = false
                    }
                   
                    
                }) {
                Image(systemName: "xmark")
                    .font(.largeTitle)
                
                
                
            }
                Spacer()
            } .padding()
            
        
            }
                HStack {
                    Text("Customization")
                        .font(.custom("Montserrat-Bold", size: 25))
                        .padding(.vertical, 20)
                    
                }
                Text("Select your classes and learning topics and we'll recommend groups where you can find studymates.")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-light", size: 15))
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                ScrollView {
                VStack(spacing: 10) {
                    ForEach(UserInterestTypes.allCases, id:\.self){name in
                        InterestSelectRow(interestSelected: $interestSelected, interestName: name)
                            
                    }
                }
                    Spacer(minLength: 200)
                }
                Spacer()
            
                if isNotOnboarding {
               
              
             //   Text("Skip for now")
                  //  .font(.custom("Montserrat-Regular", size: 17))
                    //.foregroundColor(Color.black.opacity(0.5))
                   // .padding(.bottom, 10)
                Button(action: {
                    if interestSelected != [] {
                        do{
                            try saveData()
                            userData.isOnboardingCompleted = true
                            self.viewRouter.currentView = .home
                        }
                        catch{
                            print("Failed saving user interest data, \(error)")
                        }
                        
                    }
                    
                }) {
                    Text("Finish")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                }
                .buttonStyle(BlueStyle())
                .padding(.bottom, 20)
                .padding(.horizontal, 35)
                
                }
                   
            }
        }
        .animation(.easeInOut)
        .onDisappear {
            interestSelected = interestSelected.removeDuplicates()
            for interest in interestSelected {
                interests.append(interest.rawValue)
                do {
                    
               try saveData()
                } catch {
                    print("error")
                }
        }
       
        
        
    }
    }
    
    func saveData() throws -> Void{
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userID)
        try docRef.setData(from: ["interests": interestSelected], merge: true)
        docRef.updateData(["finishedOnboarding": true]) { error in
            if let error = error {
                print("Error updating data: \(error)")
            }
        }
        if isNotOnboarding {
        self.viewRouter.updateCurrentView(view: .home)
        }
    }
    
}




struct InterestSelectRow: View {
    @Binding var interestSelected:[UserInterestTypes]
    var interestName:UserInterestTypes
    @State var selected = false
    
        var body: some View {
        HStack{
            Text(interestName.rawValue)
                .font(.custom("Montserrat-regular", size: 16))
                .foregroundColor(selected ? Color.white: Color.black.opacity(0.5))
//                .onAppear() {
//                    if interests.contains(interestArray[index].interestName) {
//                        selected = true
//                    }
//                }
                .padding(.leading, 30)
            Spacer()
            Circle()
                .fill(Color.black.opacity(0.3))
                .overlay(
                    Image(systemName: "checkmark")
                        .foregroundColor(selected ? .white : Color.white.opacity(0))
                        .font(.system(size: 20))
                )
                .frame(width: 35, height: 35)
        }
        .frame(height: 40)
        .background(
            ZStack {
                Color(#colorLiteral(red: 0.1803921569, green: 0.8, blue: 0.4431372549, alpha: 1))
                Color(#colorLiteral(red: 0.9117633104, green: 0.9051725268, blue: 0.9168094993, alpha: 1))
                    .offset(x: selected ? 1000 : 0)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .padding(.horizontal, 10)
        .onTapGesture(){
            if selected{
               interestSelected = interestSelected.filter {$0 != interestName}
            }
            else{
                interestSelected.append(interestName)
            }
            selected.toggle()
//            interests.append(interestArray[index].interestName)
//                        let db = Firestore.firestore()
//            let docRef = db.collection("users").document(userData.userID)
//            docRef.updateData(
//                  [
//                      "interests": interests
//                  ]
//              )
//            self.interestArray[index].selected = true
            hapticEngine(style: .light)
        }
        .animation(.easeInOut)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(interestName.rawValue))
        .accessibilityAddTraits(.isButton)
        .accessibilityAddTraits(selected ? .isSelected : AccessibilityTraits())
    }
}

enum UserInterestTypes:String,CaseIterable, Codable{
    case SAT = "Standardized Tests"
    case Spanish = "Spanish"
    case Algebra2 = "Algebra 2"
    case Algebra1 = "Algebra 1"
    case Chemistry = "Chemistry"
    case Physics = "Physics"
    case Biology = "Biology"
    case CS = "Computer Science"
    case CollegeApps = "College Applications"
    case Other = "Other"
    
}
