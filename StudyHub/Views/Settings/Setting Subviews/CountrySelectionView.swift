//
//  CountrySelectionView.swift
//  StudyHub
//
//  Created by Santiago Quihui on 03/01/21.
//  Copyright © 2021 Dakshin Devanand. All rights reserved.
//

import SwiftUI

struct CountrySelectionView: View {
    @ObservedObject var userData: UserData
    @State private var displayError = false
    @State private var errorObject = ErrorModel(errorMessage: "Settings can not be updated at this time", errorState: false)
    
    @Binding var selectedCountry: String
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let countries = ["US"]
    
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
                    Text("Select your country")
                        .foregroundColor(Color("Text"))
                        .font(.custom("Montserrat-SemiBold", size: 25))
                    Spacer()
                }
                .padding(.vertical, 25)
                .padding(.horizontal)
                
                VStack {
                    LazyVGrid(columns: columns, spacing: 30) {
                        ForEach(countries, id: \.self) { country in
                            CountryRow(country: country, selectedCountry: $selectedCountry)
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

struct CountryRow: View {
    var country: String
    @Binding var selectedCountry: String
    var selected: Bool {
        return selectedCountry == country
    }
    var body: some View {
        HStack {
            Image(country)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 40, maxHeight: 40)
            Spacer()
            Text(country)
                .font(.custom("Montserrat-SemiBold", size: 15))
                .foregroundColor(Color(.white))
        }
        .padding(.vertical, 15)
        .padding(.horizontal)
        .background(selected ? Color.buttonPressedBlue : Color("Background"))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .padding()
        .onTapGesture {
            selectedCountry = country
        }
    }
}

//struct NotificationsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CountrySelectionView(selectedCountry: .constant("US"))
//    }
//}
