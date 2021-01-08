//
//  LanguageSelectionView.swift
//  StudyHub
//
//  Created by Pablo Quihui on 04/01/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct LanguageSelectionView: View {
    @EnvironmentObject var userData: UserData
    @State private var displayError = false
    @State private var errorObject = ErrorModel(errorMessage: "Settings can not be updated at this time", errorState: false)
    
    @Binding var selectedLanguage: String
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let languages = ["EN"]
    let languageCountry = ["EN" : "US"]
    
    var body: some View {
        ZStack {
            
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                if displayError {
                    ErrorMessage(errorObject: errorObject, displayError: errorObject.errorState)
                }
            }
            
            
            VStack {
                
                
                HStack {
                    Text("Select your language")
                        .foregroundColor(Color("Text"))
                        .font(.custom("Montserrat-SemiBold", size: 25))
                    Spacer()
                }
                .padding(.vertical, 25)
                .padding(.horizontal)
                
                VStack {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(languages, id: \.self) { language in
                            LanguageRow(language: language, selectedLanguage: $selectedLanguage, countries: languageCountry)
                        }
                    }
                    Text("Sorry, that's all we currently support")
                        .font(.custom("Montserrat Bold", size: 24))
                        .multilineTextAlignment(.center)
                        .frame(width: 250)
                        .frame(height:425)
                }
                .padding(.vertical)
                .background(Color("Background"))
                .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .shadow(color: Color("shadow"), radius: 5)
                .padding()
                
               
            }
        }
        Spacer()
    }
}

struct LanguageRow: View {
    var language: String
    @Binding var selectedLanguage: String
    var countries: [String: String]
    var selected: Bool {
        selectedLanguage == language
    }
    var country: String {
        if let country = countries[language] {
            return country
        }
        #warning("Add default image for country")
        return "US"
    }
    var body: some View {
        HStack {
            Image(country)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 40, maxHeight: 40)
                Spacer()
            Text(language)
                .font(.custom("Montserrat-SemiBold", size: 15))
                .foregroundColor(Color(.white))
        }
        .padding(.vertical, 15)
        .padding(.horizontal)
        .background(selected ? Color.buttonPressedBlue : Color("Background"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
        .onTapGesture {
            selectedLanguage = language
        }
    }
}
struct LanguageSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LanguageSelectionView(selectedLanguage: .constant("EN"))
                .previewDevice(PreviewDevice(rawValue: "iPhone 12 Pro"))
                .previewDisplayName("iPhone 12 Pro")
            
            
            LanguageSelectionView(selectedLanguage: .constant("EN"))
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("iPhone SE")
        }
    }
}
