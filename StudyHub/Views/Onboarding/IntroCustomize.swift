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
    @State var interestToShow:[UserInterest] = [
        UserInterest(interestName: "SAT"), UserInterest(interestName: "ACT"), UserInterest(interestName: "AP Calculus"), UserInterest(interestName: "Algebra 2")
    ]
    @EnvironmentObject var userData: UserData
    @State var isNotOnboarding: Bool = false
    @Binding var interests: [String]
    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    Text("Customization")
                        .font(.custom("Montserrat-Bold", size: 25))
                        .padding(.vertical, 20)
                    
                }
                Text("Select your classes and learning topics and we'll recommend groups where you can find help.")
                    .multilineTextAlignment(.center)
                    .font(.custom("Montserrat-light", size: 15))
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
                
                VStack(spacing: 10) {
                    ForEach(interestToShow.indices){index in
                        InterestSelectRow(interestArray: $interestToShow, index: index, interests: $interests)
                            
                    }
                }
                
                
                Spacer()
                if !isNotOnboarding {
                Text("Skip for now")
                    .font(.custom("Montserrat-Regular", size: 17))
                    .foregroundColor(Color.black.opacity(0.5))
                    .padding(.bottom, 10)
                Button(action: {
                    userData.isOnboardingCompleted = true
                }) {
                    Text("Finish")
                        .font(.custom("Montserrat-SemiBold", size: 18))
                }
                .buttonStyle(BlueStyle())
                .padding(.bottom, 10)
                .padding(.horizontal, 35)
                
                }
            }
        }
        .animation(.easeInOut)
        
    }
    
    func saveData(){
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(userData.userID)
        let selectedInterest = interestToShow.filter{$0.selected}
        
        
        docRef.setData([ "interests": selectedInterest ], merge: true)
    }
    
}




struct InterestSelectRow: View {
    @Binding var interestArray:[UserInterest]
    var index:Int
    @State var selected = false
    @Binding var interests: [String]
    @EnvironmentObject var userData:UserData
    var body: some View {
        HStack{
            Text(interestArray[index].interestName)
                .font(.custom("Montserrat-regular", size: 16))
                .foregroundColor(selected ? Color.white: Color.black.opacity(0.5))
                .onAppear() {
                    if interests.contains(interestArray[index].interestName) {
                        selected = true
                    }
                }
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
            
            selected.toggle()
            interests.append(interestArray[index].interestName)
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(userData.userID)
            docRef.updateData(
                  [
                      "interests": interests
                  ]
              )
            self.interestArray[index].selected = true
            hapticEngine(style: .light)
        }
        .animation(.easeInOut)
    }
}
struct UserInterest:Hashable{
    var interestName:String
    var selected:Bool = false
}
