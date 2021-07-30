//
//  IntroMentor.swift
//  StudyHub
//
//  Created by Dakshin Devanand on 12/30/20.
//  Copyright © 2020 Dakshin Devanand. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseCore

struct IntroMentor: View {
    @ObservedObject var userData: UserData
    @ObservedObject var viewRouter:ViewRouter
    @State var mentorSelected:[UserInterestTypes] = []
    
    @State var isNotOnboarding: Bool = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        ZStack {
            
            Color(.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if !isNotOnboarding {
                    //
                    //                    HStack {
                    //                        Button(action: {
                    //
                    //
                    //
                    //                        }) {
                    //                        Image(systemName: "xmark")
                    //                            .foregroundColor(Color("Primary"))
                    //                            .font(.title)
                    //                    }
                    //                        Spacer()
                    //                    } .padding()
                    
                    
                }
                
                HStack {
                    Text("Mentor Sign-Up (Optional)")
                        .font(.custom("Montserrat-Bold", size: 25))
                        .padding(.vertical, 20)
                    
                }
                Text("Select classes you would like to be a mentor to others in and input your grade as well.")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-light", size: 15))
                    .foregroundColor(Color("Text"))
                    
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(UserInterestTypes.allCases, id:\.self){name in
                            MentorSelectionRow(mentorSelected: $mentorSelected, interestName: name)
                        }
                    }
                }
                Spacer()
                VStack{
                    Text("Tap next without a selection to skip.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color("Text"))
                        .font(.custom("Montserrat-light", size: 15))
                    Button(action: {
                        if isNotOnboarding {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            if mentorSelected != [] {
                                do{
                                    try saveData()
                                    // userData.isOnboardingCompleted = true
                                    self.viewRouter.currentView = .custom
                                }
                                catch{
                                    print("Failed saving user interest data, \(error)")
                                }
                                
                            }
                            else{
                                self.viewRouter.currentView = .custom
                            }
                        }
                    }) {
                        Text("Next")
                            .font(.custom("Montserrat-SemiBold", size: 18))
                    }
                    .buttonStyle(BlueStyle())
                    
                    
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 35)
                
                
                
                
            }
            
        }
        .animation(.easeInOut)
        
    }
    func saveData() throws -> Void{
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userID)
        try docRef.setData(from: ["mentorshipInterests": mentorSelected], merge: true)
        try docRef.setData(from: ["isMentor": true], merge: true)
        if isNotOnboarding {
            self.viewRouter.updateCurrentView(view: .home)
        }
    }
    
}

struct MentorSelectionRow: View {
    @Binding var mentorSelected:[UserInterestTypes]
    var interestName:UserInterestTypes
    @State var selected:Bool = false
    @State var chosenGrade:Int = 9
    
    var grades:[Int] = [6, 7, 8, 9, 10, 11, 12]
    
    var body: some View {
        HStack {
            HStack {
                Text(interestName.rawValue)
                    .font(.custom("Montserrat-regular", size: 16))
                    .foregroundColor(selected ? Color.white: Color.black.opacity(0.5))
                    
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
                if selected {
                    mentorSelected = mentorSelected.filter {$0 != interestName}
                }
                else{
                    mentorSelected.append(interestName)
                    // be a mentor in this interest
                }
                selected.toggle()
                
                hapticEngine(style: .light)
            }
            .animation(.easeInOut)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(interestName.rawValue))
            .accessibilityAddTraits(.isButton)
            .accessibilityAddTraits(selected ? .isSelected : AccessibilityTraits())
            
            //                if selected {
            //                    HStack { //.font(.custom("Montserrat-regular", size: 14)).foregroundColor(Color("Text"))
            //                        Picker(selection: $chosenGrade, label: HStack{
            //                                Text("Grade: ")
            //                                Text("\(chosenGrade)").bold()}) {
            //                            ForEach(grades, id: \.self) { (grade) in
            //                                Text("\(grade)")
            //                            }
            //                        }
            //                        .pickerStyle(MenuPickerStyle())
            //                        .foregroundColor(Color("Text"))
            //                        .font(.custom("Montserrat-regular", size: 14))
            //
            //                    }
            //                    .padding(.trailing, 10)
            //                }
        }
    }
}

